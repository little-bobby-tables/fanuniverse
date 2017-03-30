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
  end

  test 'generates downsized versions for raster images' do
    process! :image_large_file

    path, ext = @image.image.file.try { |f| [File.dirname(f.path), f.extension] }

    assert File.file? "#{path}/thumbnail.#{ext}"
    assert File.file? "#{path}/preview.#{ext}"
  end

  test 'generates mp4 versions for gif animations' do
    process! :image_gif

    path = File.dirname(@image.image.file.path).shellescape

    Open3.popen3("ffprobe #{path}/rendered.mp4") do |_, _, output, _|
      info = output.read
      assert info.match? /Video: h264.+500x280/
    end

    Open3.popen3("ffprobe #{path}/rendered.webm") do |_, _, output, _|
      info = output.read
      assert info.match? /Video: vp9.+500x280/
    end

    assert File.file? "#{path}/fallback.png"
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

  def process!(factory)
    @image = create(factory)
    ImageProcessingJob.perform_now(@image.id)
  end
end
