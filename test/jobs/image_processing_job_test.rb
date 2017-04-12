# frozen_string_literal: true
require 'test_helper'

class ImageProcessingJobTest < ActiveJob::TestCase
  test 'processes images' do
    @image = create(:image)

    refute @image.processed?

    ImageProcessingJob.perform_now(@image.id)

    assert @image.reload.processed?
  end

  test 'identifies image attributes' do
    process! :image

    assert_equal 200, @image.reload.width
    assert_equal 198, @image.height
    assert_equal '1011110010110011111010001010100110101000000000111110101001001011', @image.phash
  end

  test 'generates downsized versions for raster images' do
    process! :image_large_png

    path = File.dirname(@image.image.file.path).shellescape

    assert valid_image? "#{path}/thumbnail.png", 'PNG', 300
    assert valid_image? "#{path}/preview.png", 'PNG', 1280
  end

  test 'generates mp4 versions for gif animations' do
    process! :image_gif

    path = File.dirname(@image.image.file.path).shellescape

    assert valid_video? "#{path}/rendered.mp4", 'h264', '500x280'
    assert valid_video? "#{path}/rendered.webm", 'vp9', '500x280'

    assert valid_image? "#{path}/poster.jpg", 'JPEG', 500
  end

  test 'creates symbolic links for versions larger than source' do
    process! :image

    path, ext = @image.image.file.try { |f| [File.dirname(f.path), f.extension] }

    assert valid_symlink? "#{path}/thumbnail.#{ext}"
    assert valid_symlink? "#{path}/preview.#{ext}"
  end

  def valid_symlink?(path)
    File.symlink?(path) && File.exist?(File.readlink(path))
  end

  def valid_image?(path, type, width)
    Open3.popen3("identify #{path}") do |_, output, _, _|
      info = output.read
      assert info.match? /#{type} #{width}x\d+/
    end
  end

  def valid_video?(path, type, dimensions)
    Open3.popen3("ffprobe #{path}") do |_, _, output, _|
      info = output.read
      assert info.match? /Video: #{type}.+#{dimensions}/
    end
  end

  def process!(factory)
    @image = create(factory)
    ImageProcessingJob.perform_now(@image.id)
  end
end
