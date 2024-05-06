class WaterBillingController < ApplicationController
    before_action :set_water_billing, only: %i[ show edit update destroy upload_image]
    # GET /water_billings or /water_billings.json
    def index
      water_billing_repository = WaterBillingRepository.new(params, subdivision.id)
      @water_billings = water_billing_repository.search_water_billing
      @total_current_reading = WaterBillingTransactionRepository.sum_current_reading_by_month(params[:year_list] || Time.now.year)
    end
  
    # GET /water_billings/1 or /water_billings/1.json
    def show
    end
  
    # GET /water_billings/new
    def new
      @water_billing = WaterBilling.new
    end
  
    # GET /water_billings/1/edit
    def edit
    end
  
    # POST /water_billings or /water_billings.json
    def create
      @water_billing =  WaterBillingRepository.new(water_billing_params, subdivision.id)
      @water_billing = @water_billing.create
    end
  
    # PATCH/PUT /water_billings/1 or /water_billings/1.json
    def update
      begin
        updates_billing_params = WaterBillingRepository.set_up_update_param(@water_billing, water_billing_params)
        @water_billing.update(updates_billing_params)
        @total_current_reading = WaterBillingTransactionRepository.sum_current_reading_by_month(@water_billing.year || Time.now.year)
      rescue => e
        @update_error = true
        @update_error_message = e
        logger.debug e
        logger.debug e.backtrace.join("\n")
        render status: :bad_request
      end
    end
  
    # DELETE /water_billings/1 or /water_billings/1.json
    def destroy
      begin
        @water_billing.destroy!
        render status: :no_content
      rescue => e
        render json: {error:{message:e.message}}, status: :bad_request
      end
    end
  
    def upload_image
      begin
        photo = @water_billing.photos.find_by(name: upload_image_params["name"])
        if photo.nil?
            @water_billing.photos.create(name: upload_image_params["name"], image: upload_image_params["image"])
        else
            photo.destroy
            @water_billing.photos.create(name: upload_image_params["name"], image: upload_image_params["image"])
        end
        @total_current_reading = WaterBillingTransactionRepository.sum_current_reading_by_month(@water_billing.year || Time.now.year)
      rescue => e
        @upload_image_error = true
        @upload_image_error_message = e
        render status: :bad_request
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_water_billing
        begin
          @water_billing = WaterBilling.find(params[:id])
        rescue => e
          render json: {error:{message:e.message}}, status: 404
        end
      end
  
      # Only allow a list of trusted parameters through.
      def water_billing_params
        params.require(:water_billing).permit(
          :mother_meter_current_reading,
          :bill_amount,
          :year,
          :month,
          :paid_amount
        )
      end
  
      def upload_image_params
        params.require(:water_billing).permit(
          :name,
          :id,
          :image
        )
      end
  end
  