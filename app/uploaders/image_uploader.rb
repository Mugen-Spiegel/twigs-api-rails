class ImageUploader < Shrine
    # plugins and uploading logic
    Attacher.validate do
      validate_mime_type %w[image/jpeg image/png image/webp image/tiff]
      validate_extension %w[jpg jpeg png webp tiff tif]
    end
  end