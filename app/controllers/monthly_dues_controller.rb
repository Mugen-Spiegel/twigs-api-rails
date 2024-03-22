class MonthlyDuesController < ApplicationController

    def index
        @monthly_dues = MonthlyDueRepository.get_monthly_due(subdivision)
    end
    def create
        @monthly_dues = MonthlyDueRepository.create(params, subdivision)
        unless @monthly_dues.valid?
            render status: :bad_request
        end
    end
end
