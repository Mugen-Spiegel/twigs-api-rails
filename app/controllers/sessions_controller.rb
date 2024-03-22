class SessionsController < ApplicationController
    
    skip_before_action :authenticate_user
      def new
        # No need for anything in here, we are just going to render our
        # new.html.erb AKA the login page
      end
    
      def create
        # Look up User in db by the email address submitted to the login form and
        # convert to lowercase to match email in db in case they had caps lock on:
        user = User.includes(:subdivision).find_by(email: login_params[:email].downcase)

        # Verify user exists in db and run has_secure_password's .authenticate() 
        # method to see if the password submitted on the login form was correct: 
        if !user.nil? && user.authenticate(login_params[:password]) 
          # Save the user.id in that user's session cookie:
          token = jwt_encode({user_id: user.id})
          time = Time.now + 24.hours.to_i
          render json: {
            token: token,
            user: user,
            subdivision: user.subdivision
          }
        else
          # if email or password incorrect, re-render login page:
          render status: :unauthorized, json: { errors: "Invalid Username and Password"}
        end
      end
    
      def destroy
        # delete the saved user_id key/value from the cookie:
        session.delete(:user_id)
        redirect_to login_path, notice: "Logged out!"
      end
      
    def login_params
        params.require(:login).permit(:email, :password, :password_confirmation)
    end
    end

    