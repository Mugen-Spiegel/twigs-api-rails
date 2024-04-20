if @update_error
    json.error do
        json.message @update_error_message
    end
else
    json.data do
        json.monthly_due_transaction @monthly_due_transaction
    end
end
