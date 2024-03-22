class CreateWaterBillings < ActiveRecord::Migration[7.1]
  def change
    create_table :water_billings do |t|
      t.integer :month
      t.integer :year
      t.integer :mother_meter_current_reading, default: 0
      t.integer :mother_meter_previous_reading, default: 0
      t.integer :consumption, default: 0
      t.string :is_paid
      t.integer :residence_count, default: 0
      t.float :bill_amount, default: 0
      t.float :per_cubic_price, default: 0
      t.float :paid_amount, default: 0
      t.integer :number_residence, default: 0
      t.belongs_to :subdivision
      t.timestamps
      t.index [:month, :year ], unique: true
    end

  end
end
