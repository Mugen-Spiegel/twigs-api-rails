
json.data do
    json.residence @residence do |r|
        json.id r.id
        json.uuid r.uuid
        json.admin r.admin
        json.name do
            json.first_name r.first_name
            json.last_name r.last_name
            json.middle_name r.middle_name
        end
        json.address do
            json.block r.block
            json.lot r.lot
            json.street r.street
        end
        json.balance do
            json.monthly_due_transactions r.monthly_due_transactions_balance
            json.water_billing_transactions r.water_billing_transactions_balance
        end
        
    end
end
