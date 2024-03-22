class WaterBillingTransaction < ApplicationRecord

    include StatusList
    
    belongs_to :user
    belongs_to :water_billing
    belongs_to :subdivision

    enum :month, {January:1, February:2, March:3, April:4, May:5, June:6, July:7, August:8, September:9, October:10, November:11, December:12}
    
    # Dito na ko
    after_update -> { WaterBillingTransactionRepository.after_update_callback(self) }
    
    scope :users_with_unpaid_bill, -> (where_clause, where_like_clause) do
        joins(:user)
        .where(where_clause).where(where_like_clause)
        .select("
            SUM(water_billing_transactions.consumption) as total_consumption,
            SUM(water_billing_transactions.bill_amount) as total_bill_amount,
            SUM(water_billing_transactions.paid_amount) as total_paid_amount,
            SUM(CASE
                WHEN water_billing_transactions.is_paid='unpaid' THEN 
                COALESCE(water_billing_transactions.bill_amount,0)
                ELSE (COALESCE(water_billing_transactions.bill_amount,0) - COALESCE(water_billing_transactions.paid_amount,0)) 
            END) as total_balance
                ")
        .distinct("water_billing_transactions.month")
    end
    
end
