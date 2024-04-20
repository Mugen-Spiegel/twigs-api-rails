class MonthlyDueTransactionRepository

    attr_accessor :street, :status, :year, :month, :subdivision_id, 
    :first_name, :last_name, :sort_by, :direction, :where_clause, :where_like_clause

    def initialize(params, subdivision_id)
        self.year = params["year"] || Time.now.year
        self.month = params["month"] || "Select month"
        self.first_name = params["first_name"] || ""
        self.last_name = params["last_name"] || ""
        self.subdivision_id = subdivision_id
        self.sort_by = params["sort_by"]
        self.direction = "DESC"
        self.status = params["status"] || "Select status"
        self.street = params["street"] || "Select Street"
        self.where_clause = {}
        self.where_like_clause = ""
    end

    def list_of_monthly_dues_transaction
        prepare_where_clause
        puts self.where_clause, self.where_like_clause
        MonthlyDueTransaction.joins(:user, :monthly_due)
        .select("DISTINCT(monthly_due_transactions.id) AS id,
        monthly_due_transactions.is_paid as status,
        monthly_due_transactions.bill_amount,
        monthly_due_transactions.paid_amount,
        CONCAT('Block ', users.block, ' Lot ', users.lot, ' ', users.street, ' Street') AS address,
        CONCAT(users.first_name,' ', users.last_name) AS name,
        monthly_due_transactions.month as month")
        .where(self.where_clause).where(self.where_like_clause)
        .where("monthly_dues.subdivision_id = ?", self.subdivision_id)
        .order("#{self.sort_by}": self.direction)
    end

    def prepare_where_clause
        self.where_clause = unless self.month == "Select month"
            {month: Date::MONTHNAMES.index(self.month)}
        else
            {month: ..12}
        end

        unless self.first_name.empty?
            self.where_like_clause += "users.first_name LIKE '%#{self.first_name.downcase}%'" 
        end

        unless self.last_name.empty?
            unless self.first_name.empty?
                self.where_like_clause += " AND "
            end
            self.where_like_clause += "users.last_name LIKE '%#{self.last_name.downcase}%'" 
        end

        self.where_clause["monthly_due_transactions.year"] = self.year

        unless self.status == "Select status"
            self.where_clause["monthly_due_transactions.is_paid"] = self.status
        end

        unless self.street == "Select Street"
            self.where_clause["users.street"] = self.street.downcase
        end

        if self.sort_by.nil?
            self.sort_by = "monthly_due_transactions.month"
        end
    end

    def self.create_monthly_due_transaction(subdivision_id)
        current_month = current_monthly_dues
        monthly_due_transaction = []
        monthly_due = subdivision_monthly_due(subdivision_id)

        if monthly_due.present? && current_month.empty?
            User.where(subdivision_id: subdivision_id, admin: false).each do |user|
                monthly_due_transaction << {
                    is_paid: MonthlyDueTransaction::UN_PAID,
                    bill_amount: monthly_due.amount,
                    user_id: user.id,
                    year: Time.now.year,
                    month: Date::MONTHNAMES[Time.now.month],
                    monthly_due_id: monthly_due.id,
                }
            end
    
            ids = MonthlyDueTransaction.insert_all(monthly_due_transaction)
            current_monthly_dues
        else
            unless current_month.nil?
                raise StandardError.new("#{Date::MONTHNAMES[Time.now.month]} monthly dues already existing")
            else
                raise StandardError.new("no active monthly dues amount")
            end
        end
    end

    def self.subdivision_monthly_due(subdivision_id)
        MonthlyDue.where(subdivision_id: subdivision_id, is_current: "true").first
    end

    def self.current_monthly_dues
        MonthlyDueTransaction.where(year: Time.now.year, month: Date::MONTHNAMES[Time.now.month])
    end


    def self.prepaire_update_params(monthly_due_transaction, params)
        unless params["paid_amount"].nil?
            params["paid_amount"] = (params["paid_amount"].to_f  + monthly_due_transaction.paid_amount).round(2)
            if ( params["paid_amount"].to_f == monthly_due_transaction.bill_amount )
                params["is_paid"] = WaterBillingTransaction::PAID
            elsif ( params["paid_amount"].to_f > monthly_due_transaction.bill_amount )
                raise StandardError.new("Paid Amount should not greater than bill amount")
            else
                params["is_paid"] = WaterBillingTransaction::PARTIAL
            end
        end
        params
    end
end