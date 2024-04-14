json.data do
    json.water_billings @water_billings.each do |bill|
        json.id  bill.id
        json.month Date::MONTHNAMES[bill.month]
        json.mother_meter_current_reading bill.mother_meter_current_reading
        json.mother_meter_previous_reading bill.mother_meter_previous_reading
        json.consumption bill.consumption
        json.resident_consumption @total_current_reading[bill.month] || 0
        json.system_loss (bill.consumption - (@total_current_reading[bill.month] || 0))
        json.number_residence bill.number_residence
        json.per_cubic_price bill.per_cubic_price
        json.bill_amount bill.bill_amount
        json.paid_amount bill.paid_amount
        json.balance bill.bill_amount - bill.paid_amount
        json.photos bill&.photos.each do |photo|
            json.image_url photo.image_url
            json.name photo.name
        end
        json.is_paid bill.is_paid 
    end
end
