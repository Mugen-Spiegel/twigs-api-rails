if @update_error
    json.error do
        json.message @update_error_message
    end
else
    json.data do
        json.water_billings do
            json.id  @water_billing.id
            json.month Date::MONTHNAMES[@water_billing.month]
            json.mother_meter_current_reading @water_billing.mother_meter_current_reading
            json.mother_meter_previous_reading @water_billing.mother_meter_previous_reading
            json.consumption @water_billing.consumption
            json.resident_consumption @total_current_reading[@water_billing.month] || 0
            json.system_loss (@water_billing.consumption - (@total_current_reading[@water_billing.month] || 0))
            json.number_residence @water_billing.number_residence
            json.per_cubic_price @water_billing.per_cubic_price
            json.bill_amount @water_billing.bill_amount
            json.paid_amount @water_billing.paid_amount
            json.balance @water_billing.bill_amount - @water_billing.paid_amount
            json.photos @water_billing&.photos.each do |photo|
                json.image_url photo.image_url
                json.name photo.name
            end
            json.is_paid @water_billing.is_paid 
        end
    end
end
