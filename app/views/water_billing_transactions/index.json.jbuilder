
json.data do
    json.table_footer @totals
    json.water_billing_transaction @water_billing_transactions do |water_billing_transaction|
        json.id water_billing_transaction.id
        json.created_at water_billing_transaction.created_at
        json.month water_billing_transaction.month
        json.consumption water_billing_transaction.consumption
        json.bill_amount water_billing_transaction.bill_amount
        json.paid_amount water_billing_transaction.paid_amount
        json.balance water_billing_transaction.balance
        json.current_reading water_billing_transaction.current_reading
        json.previous_reading water_billing_transaction.previous_reading
        json.price_per_cubic water_billing_transaction.price_per_cubic
        json.status water_billing_transaction.status
        json.address do
            json.block water_billing_transaction.block
            json.lot water_billing_transaction.lot
            json.street  water_billing_transaction.street
        end
        json.residence do
            json.user_id  water_billing_transaction.user_id
            json.first_name water_billing_transaction.first_name
            json.middle_name water_billing_transaction.middle_name
            json.last_name water_billing_transaction.last_name
        end
    end
end
