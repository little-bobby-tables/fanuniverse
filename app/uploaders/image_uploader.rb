class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def extension_whitelist
    %w(png jpg jpeg gif svg)
  end

  def content_type_whitelist
    %w(image/png image/jpeg image/gif image/svg\+xml)
  end

  def store_dir
    "uploads/images/#{model.id}"
  end
end
