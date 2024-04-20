if @monthly_due_error
    json.error do
        json.message @monthly_due_error_message
    end
else
    json.data do
        json.monthly_due @monthly_dues_transactions
    end
end
