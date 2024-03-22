class MonthlyDueTransactionRepository

    def self.list_of_monthly_dues_transaction(subdivision_id, params)
        MonthlyDueTransaction.joins(:users).where(
            subdivision_id: subdivision_id,
            month: params['month'],
            year: params['year'],
            "users.first_name": params['first_name'],
            "users.last_name": params['last_name'],
        )
    end

    def self.create_monthly_due_transaction(subdivision_id)
        monthly_due_transaction = []
        monthly_due = subdivision_monthly_due(subdivision_id)
        unless monthly_due.nil?
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
            
            MonthlyDueTransaction.where(id: ids)
        else
            raise ActiveRecord::RecordNotFound
        end
    end

    def self.subdivision_monthly_due(subdivision_id)
        MonthlyDue.where(subdivision_id: subdivision_id, is_current: "true").first
    end

end