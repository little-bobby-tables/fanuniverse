# frozen_string_literal: true
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def extension_whitelist
    %w(png jpg jpeg gif)
  end

  def content_type_whitelist
    %w(image/png image/jpeg image/gif)
  end

  def store_dir
    "system/images/#{model.id}"
  end

  def filename
    "source.#{file.extension}" if original_filename
  end

  def url
    "#{Settings[:image_url_root]}/#{model.id}/source.#{file.extension}"
  end

  def animated?
    file.content_type == 'image/gif'
  end

  ImageProcessor::VERSIONS.each do |version, _|
    define_method "#{version}_url" do
      "#{Settings[:image_url_root]}/#{model.id}/#{version}.#{file.extension}"
    end
  end

  ImageProcessor::ANIMATED_VERSIONS.each do |version, file|
    define_method "#{version}_url" do
      "#{Settings[:image_url_root]}/#{model.id}/#{file}"
    end
  end
end
