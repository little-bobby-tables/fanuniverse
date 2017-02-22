class ImageProcessor
  VERSIONS = {
    'thumbnail' => 300,
    'preview' => 1600
  }

  GENERATORS = {
    default: ->(path, ext, version, width) do
      MiniMagick::Tool::Convert.new do |cmd|
        cmd.resize width
        cmd << "#{path}/source.#{ext}"
        cmd << "#{path}/#{version}.#{ext}"
      end
    end
  }

  LINK_VERSION_TO_SOURCE = ->(path, ext, version) do
    FileUtils.ln_s "#{path}/source.#{ext}", "#{path}/#{version}.#{ext}"
  end

  def initialize(image_record)
    @record = image_record
    @file = image_record.image.file
  end

  def process!
    analyze!
    generate_versions!
  end

  def analyze!
    image = MiniMagick::Image.open @file.path
    width, height = image.dimensions

    @record.update_columns width: width, height: height
  end

  def generate_versions!
    path = File.dirname @file.path
    type = @file.content_type
    extension = @file.extension

    VERSIONS.each do |version_name, width|
      if width < @record.width
        (GENERATORS[type] || GENERATORS[:default]).call(path, extension, version_name, width)
      else
        LINK_VERSION_TO_SOURCE.call(path, extension, version_name)
      end
    end
  end
end
