class WaterBillingTransactionsController < ApplicationController

    before_action :set_water_billing_transaction, only: %i[  update destroy ]
  
    # GET /water_billing_transactions or /water_billing_transactions.json
    def index
      water_billing_transaction = WaterBillingTransactionRepository.new(params, subdivision.id)
      @water_billing_transactions = water_billing_transaction.search_water_billing_transaction
      @totals = water_billing_transaction.get_monthly_unpaid_bills
    end
  
    # POST /water_billing_transactions or /water_billing_transactions.json
    def create
    end
  
    # PATCH/PUT /water_billing_transactions/1 or /water_billing_transactions/1.json
    def update
      params = WaterBillingTransactionRepository.calculate_bill_amount(@water_billing_transaction, water_billing_transaction_params)
      @update_valid = @water_billing_transaction.update(params) 
    end
  
    # DELETE /water_billing_transactions/1 or /water_billing_transactions/1.json
    def destroy
      @water_billing_transaction.destroy!
  
      respond_to do |format|
        format.html { redirect_to water_billing_transactions_url, notice: "Water billing transaction was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_water_billing_transaction
        @water_billing_transaction = WaterBillingTransaction.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def water_billing_transaction_params
        params.require(:water_billing_transaction).permit(:current_reading, :previous_reading, :paid_amount, :id, :subdivision_id, :water_billing_id)
      end
end
  