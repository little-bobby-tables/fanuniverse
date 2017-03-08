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
    if Rails.env.test?
      "test/images/#{model.id}"
    else
      "system/images/#{model.id}"
    end
  end

  def filename
    "source.#{file.extension}" if original_filename
  end

  def url
    "#{Settings[:image_root]}/#{model.id}/source.#{file.extension}"
  end

  ImageProcessor::VERSIONS.each do |version, _|
    define_method "#{version}_url" do
      "#{Settings[:image_root]}/#{model.id}/#{version}.#{file.extension}"
    end
  end
end
