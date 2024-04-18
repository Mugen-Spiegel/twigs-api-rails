class ResidenceController < ApplicationController


    before_action :residence, only: %i[ show ]

    def index
        residence_repositories = ResidenceRepositories.new(params, subdivision)
        @residence =  residence_repositories.search_residence
    end

    def show

    end

    def create
      @residence = ResidenceRepositories.create(param_create, subdivision)
      unless @residence.valid?
        render status: :bad_request
      end
    end

    private

    def residence
        @residence = User.find_by(uuid: params[:id])
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
end
