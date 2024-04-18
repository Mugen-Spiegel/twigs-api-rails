unless @update_valid
    json.error do
        unless @validation_error_message.nil?
            json.message @validation_error_message
        else
            json.message @water_billing_transaction.errors
        end
    end
else
    json.data do
        json.water_billing_transaction @water_billing_transaction
    end
end
