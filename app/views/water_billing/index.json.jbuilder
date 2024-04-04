json.data do
    json.water_billings @water_billings.each do |bill|
        json.id  bill.id
        json.month bill.month
        json.mother_meter_current_reading bill.mother_meter_current_reading
        json.mother_meter_previous_reading bill.mother_meter_previous_reading
        json.consumption bill.consumption
        json.is_paid bill.is_paid
        json.bill_amount bill.bill_amount
        json.per_cubic_price bill.per_cubic_price
        json.paid_amount bill.paid_amount
        json.number_residence bill.number_residence
        json.photos bill&.photos
    end
    json.total_current_reading @total_current_reading
end
