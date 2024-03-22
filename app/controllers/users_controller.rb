class UsersController < ApplicationController

    def create

    end

    def login
        user = User.find_by(username: login_params[:username])
        if user.nil? && user.authenticate(login_params[:password])
            
        end
    end
    
    private
    
    def login_params
        params.require(:login).permit(:username, :password, :password_confirmation)
    end
end
