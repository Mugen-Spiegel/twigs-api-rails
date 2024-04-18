
unless @residence.valid?
    json.error do
        json.message @residence.errors
    end
else
    json.data do
        json.residence @residence
    end
end
