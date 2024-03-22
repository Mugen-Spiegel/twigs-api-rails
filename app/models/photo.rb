class Photo < ActiveRecord::Base
    include ImageUploader::Attachment(:image)

    validates :water_billing_id, :name, :image_data, presence: true
end