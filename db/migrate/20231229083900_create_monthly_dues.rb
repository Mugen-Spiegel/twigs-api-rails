class CreateMonthlyDues < ActiveRecord::Migration[7.1]
  def change
    create_table :monthly_dues do |t|
      t.string :amount
      t.string :is_current
      t.belongs_to :subdivision
      t.timestamps
    end

  end
end
