unless @update_valid
    json.error do
        json.message @water_billing_transaction.errors
    end
else
    json.data do
        json.water_billing_transaction @water_billing_transaction
    end
end
