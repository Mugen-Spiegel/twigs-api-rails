class MonthlyDuesTransactionsController < ApplicationController

    def index
        begin
            @monthly_dues_transactions = MonthlyDueTransactionRepository.list_of_monthly_dues_transaction(subdivision.id, params)
            @monthly_due_error = false
        rescue ActiveRecord::RecordNotFound => e
            @monthly_due_error = true
            render status: :bad_request
        end
    end

    def create
        begin
            @monthly_dues_transactions = MonthlyDueTransactionRepository.create_monthly_due_transaction(subdivision.id)
            @monthly_due_error = false
        rescue ActiveRecord::RecordNotFound => e
            @monthly_due_error = true
            render status: :bad_request
        end
    end
end
 