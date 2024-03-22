require 'jwt'

class ApplicationController < ActionController::API


    before_action :authenticate_user, :subdivision

    def authenticate_user
        header = request.headers["Authorization"]
        header = header.split(' ').last if header
        begin
            puts header
            @decoded = jwt_decode(header)
            @current_user = User.find(@decoded[:user_id])
            
        rescue ActiveRecord::RecordNotFound => e
            render status: :unauthorized, json: { errors: e.message}
        rescue JWT::DecodeError => e
            render status: :unauthorized, json: { errors: e.message}
        end
    end
    
    def current_user
        @current_user
    end

    def  jwt_encode(payload, exp: Time.current)
        payload[:exp] = (exp +  + 1.days).to_i
        JWT.encode(payload, Rails.application.credentials.JWT_SECKET_KEY)
    end

    def jwt_decode(token)
        decoded = JWT.decode(token, Rails.application.credentials.JWT_SECKET_KEY)[0]
        HashWithIndifferentAccess.new decoded
    end

    private
    
    def subdivision
        unless params[:subdivision_uuid].nil?
            if current_user.subdivision.uuid == params[:subdivision_uuid]
                current_user.subdivision
            else
                render status: 403, json: { errors: "Invalid Subdivision"}
            end
        end
        
    end
end
