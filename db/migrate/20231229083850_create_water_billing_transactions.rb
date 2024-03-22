class CreateWaterBillingTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :water_billing_transactions do |t|
      t.integer :current_reading, default: 0
      t.integer :previous_reading, default: 0
      t.integer :consumption, default: 0
      t.string :is_paid
      t.float :bill_amount, default: 0
      t.float :paid_amount, default: 0
      t.integer :month
      t.integer :year
      t.belongs_to :user
      t.belongs_to :subdivision
      t.belongs_to :water_billing
      t.timestamps
    end
  end
end
