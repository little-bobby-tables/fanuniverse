# frozen_string_literal: true
class ImageAnalyzer
  def initialize(image_record)
    @image = image_record
    @path = image_record.image.file.path
  end

  def run
    @image.update_columns image_properties
  end

  private

  def image_properties
    magick = MiniMagick::Image.open @path
    phash = Phashion::Image.new @path

    {}.tap do |p|
      p[:width], p[:height] = magick.dimensions
      p[:phash] = phash.fingerprint
    end
  end
end
