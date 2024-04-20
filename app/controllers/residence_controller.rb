class ResidenceController < ApplicationController


    before_action :residence, only: %i[ show update]

    def index
        residence_repositories = ResidenceRepositories.new(params, subdivision)
        @residence =  residence_repositories.search_residence
    end


    def create
      @residence = ResidenceRepositories.create(param_create, subdivision)
      unless @residence.valid?
        render status: :bad_request
      end
    end

    def update
        begin
            unless @residence.update!(param_update)
                @update_error = true
                @update_error_message = @residence.errors
            end
        rescue => e
            @update_error = true
            @update_error_message = e
            logger.debug e
            logger.debug e.backtrace.join("\n")
            
            render status: :bad_request
        end
    end

    private

    def residence
        begin
            @residence = User.find_by(uuid: params[:residence_uuid])
        rescue => e
            render json: {error:{message:e.message}}, status: 404
        end
    end

    def param_create
        params.require(:residence).permit(
            :first_name,
            :middle_name,
            :last_name,
            :block,
            :lot,
            :street,
            :email,
            :password,
            :password_confirmation
        )
    end
    
    def param_update
        params.require(:residence).permit(
            :first_name,
            :middle_name,
            :last_name,
            :block,
            :lot,
            :street,
            :email
        )
    end
end
