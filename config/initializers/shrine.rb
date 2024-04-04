require "shrine"
require "shrine/storage/s3"

s3_options = {
  bucket:            "subdivision-tool-image",
  region:            "ap-southeast-1",
  access_key_id:     Rails.application.credentials.aws.access_key_id,
  secret_access_key: Rails.application.credentials.aws.secret_access_key,
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options), # temporary
  store: Shrine::Storage::S3.new(**s3_options),                  # permanent
}
Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :validation_helpers
Shrine.plugin :validation