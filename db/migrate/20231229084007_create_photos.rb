class CreatePhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :photos do |t|
      t.references :water_billing, foreign_key: true
      t.text       :name
      t.text       :image_data
      t.timestamps
    end
  end
end
