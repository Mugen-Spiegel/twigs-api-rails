class MonthlyDueRepository


    def self.get_monthly_due(subdivision)
        MonthlyDue.where(subdivision_id: subdivision.id).order(is_current: :desc)
    end

    def self.create(params, subdivision)
        monthly_due = MonthlyDue.create(
            amount: params[:amount],
            is_current: params[:is_current],
            subdivision_id: subdivision.id
        )

        if monthly_due.valid?
            MonthlyDue.where.not(id: monthly_due.id).update_all(is_current: "false")
        end
        monthly_due
    end
end