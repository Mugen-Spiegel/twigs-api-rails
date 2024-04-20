class MonthlyDuesTransactionsController < ApplicationController

    before_action :monthly_due_transaction, only: %i[update]

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

    def update
        begin
            params = MonthlyDueTransactionRepository.prepaire_update_params(monthly_due_transaction, param_update)
            puts params
            unless @monthly_due_transaction.update!(params)
                @update_error = true
                @update_error_message = @monthly_due_transaction.errors
            end
        rescue => e
            @update_error = true
            @update_error_message = e
            logger.debug e
            logger.debug e.backtrace.join("\n")
            render status: :bad_request
        end
    end

    private

    def monthly_due_transaction
        begin
            @monthly_due_transaction = MonthlyDueTransaction.find_by(id: params[:id])
        rescue => e
            render json: {error:{message:e.message}}, status: 404
        end
    end

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
    def param_update
        params.require(:monthly_due_transaction).permit(
            :paid_amount
        )
    end

end
 