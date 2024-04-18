class ResidenceRepositories

    attr_accessor :first_name, :where_like_clause, :subdivision_id, :last_name, :street

    def initialize(params, subdivision_id)
        self.first_name = params["first_name"] || ""
        self.last_name = params["last_name"] || ""
        self.street = params["street"] || ""
        self.subdivision_id = subdivision_id
        self.where_like_clause = ""
    end

    def search_residence

        self.where_like_clause += "admin = false" 
        unless self.first_name.empty?
            and_where
            self.where_like_clause += "first_name LIKE '%#{self.first_name.downcase}%'" 
        end

        unless self.last_name.empty?
            and_where
            self.where_like_clause += "last_name LIKE '%#{self.last_name.downcase}%'" 
        end

        if self.street != "Select Street"
            and_where
            self.where_like_clause += "street LIKE '%#{self.street.downcase}%'" 
        end

        User.search_residence(self.subdivision_id, self.where_like_clause)
    end

    def and_where
        self.where_like_clause += " AND "
    end


    def self.create(params, subdivision)
        User.create(
            first_name: params[:first_name]&.downcase,
            middle_name: params[:middle_name]&.downcase,
            last_name: params[:last_name]&.downcase,
            block: params[:block],
            lot: params[:lot],
            street: params[:street]&.downcase,
            email: params[:email]&.downcase,
            password: params[:password],
            password_confirmation:  params[:password_confirmation],
            subdivision_id: subdivision.id,
        )
    end



end