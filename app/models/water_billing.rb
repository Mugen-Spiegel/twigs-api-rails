class WaterBilling < ApplicationRecord

    include StatusList
    
    attr_accessor :image
    
    has_many :photos, dependent: :destroy
    
    accepts_nested_attributes_for :photos, allow_destroy: true

    has_many :water_billing_transactions, dependent: :destroy
    validate :validation_current_reading_billing?, on: :create
    validates :month, :year, :mother_meter_current_reading, presence: true, on: :create
    validate :validation_month_billing?, on: :create
    belongs_to :subdivision

    after_create -> { WaterBillingTransactionRepository.new({}, self.subdivision_id).after_create_callback(self) }
    before_update -> do
        if self.paid_amount == self.bill_amount
            self.is_paid = PAID
        elsif self.paid_amount > 0
            self.is_paid = PARTIAL
        elsif self.paid_amount == 0
            self.is_paid = UN_PAID
        end
    end

    def validation_month_billing?
        unless WaterBilling.where(year: self.year, month: self.month).empty?
            errors.add(:month,  "target is already existing")
        end
    end 

    def validation_current_reading_billing?
        
        water_billing = WaterBilling.last
        unless water_billing.nil?
            puts self.to_json, water_billing.to_json, water_billing.nil?
            unless self&.mother_meter_current_reading > water_billing&.mother_meter_current_reading
                errors.add(:current_reading,  "should greater than the previous reading")
            end
        end
        
    end 
end
