class AvatarUploader < CarrierWave::Uploader::Base
  storage :file

  # TODO: validate width & height

  def store_dir
    'uploads/avatars'
  end

  def filename
    if original_filename.present?
      key = Digest::MD5.hexdigest("#{model.created_at.to_i}#{file.path}")
      "#{key}.#{file.extension}"
    end
  end

  def extension_whitelist
    %w(png jpg jpeg gif)
  end

  def content_type_whitelist
    %w(image/png image/jpeg image/gif)
  end

  def size_range
    0...300.kilobytes
  end
end
