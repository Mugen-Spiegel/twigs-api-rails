class MonthlyDuesTransactionsController < ApplicationController

    def index
        begin
            @monthly_dues_transactions = MonthlyDueTransactionRepository.new(monthly_due_transaction_params, subdivision.id)
            @monthly_dues_transactions = @monthly_dues_transactions.list_of_monthly_dues_transaction
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
        rescue StandardError => e
            @monthly_due_error = true
            @monthly_due_error_message = e
            render status: :bad_request
        end
    end

    private

    def monthly_due_transaction_params
        params.permit(
            :month,
            :year,
            :first_name,
            :last_name,
            :status,
            :street,
            :subdivision_uuid
        )
    end

    # def create_monthly_due_transaction_params
    #     params.require(:month)
    # end
end
 