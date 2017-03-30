# frozen_string_literal: true
class ImageProcessor
  VERSIONS = {
    'thumbnail' => 300,
    'preview'   => 1280
  }.freeze

  def initialize(image_record)
    @image = image_record
    @file = image_record.image.file
  end

  def process!
    analyze
    generate_versions
  end

  private

  def analyze
    image = MiniMagick::Image.open @file.path
    width, height = image.dimensions

    @image.update_columns width: width, height: height
  end

  def generate_versions
    generator = case @file.content_type
      when 'image/gif'
        AnimatedGif
      else
        RasterImage
    end

    generator
      .new(@file.path, @file.extension, @image.width)
      .run
  end

  class Generator
    def initialize(source_file_path, extension, width)
      @path = File.dirname(source_file_path).shellescape
      @extension = extension
      @source_width = width
    end
  end

  class RasterImage < Generator
    def run
      VERSIONS.each { |name, w| create_version name, w }
    end

    def create_version(filename, width)
      if @source_width > width
        MiniMagick::Tool::Convert.new do |c|
          c.resize width
          c << "#{@path}/source.#{@extension}"
          c << "#{@path}/#{filename}.#{@extension}"
        end
      else
        FileUtils.ln_s "#{@path}/source.#{@extension}",
                       "#{@path}/#{filename}.#{@extension}"
      end
    end
  end

  class AnimatedGif < Generator
    def run
      # Create an MP4/H264 version
      system 'ffmpeg',
             '-f',        'gif',
             '-i',        "#{@path}/source.gif",
             '-crf',      '22',
             '-pix_fmt',  'yuv420p',
             '-preset',   'slow',
             '-movflags', '+faststart',
             '-vf',       'scale=trunc(iw/2)*2:trunc(ih/2)*2',
             '-c:v',      'libx264',
             "#{@path}/rendered.mp4"

      # Create a WebM/VP9 version
      system 'ffmpeg',
             '-f',              'gif',
             '-i',              "#{@path}/source.gif",
             '-pix_fmt',        'yuv420p',
             '-c:v',            'libvpx-vp9',
             '-crf',            '22',
             '-b:v',            '1200K',
             '-tile-columns',   '6',
             '-frame-parallel', '1',
             "#{@path}/rendered.webm"

      # Create a fallback thumbnail
      system 'ffmpeg',
             '-i',       "#{@path}/rendered.mp4",
             '-vframes', '1',
             "#{@path}/fallback.png"
    end
  end
end
