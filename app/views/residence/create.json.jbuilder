
unless @user.valid?
    json.error do
        json.message @user.errors
    end
else
    json.data do
        json.residence @user
    end
end
