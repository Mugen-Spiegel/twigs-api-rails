unless @water_billing.valid?
    json.error do
        json.message @water_billing.errors
    end
else
    json.data do
        json.residence @water_billing
    end
end
