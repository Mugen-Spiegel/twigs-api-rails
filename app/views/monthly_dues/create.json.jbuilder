
unless @monthly_dues.valid?
    json.error do
        json.message @monthly_dues.errors
    end
else
    json.data do
        json.monthly_due @monthly_dues
    end
end
