require 'test_helper'

class ImageProcessingJobTest < ActiveJob::TestCase
  test 'processes images' do
    @image = create(:image_small_file)

    refute @image.processed?

    ImageProcessingJob.perform_now(@image.id)

    assert @image.reload.processed?
  end

  test 'identifies image attributes' do
    process! :image_small_file

    assert_equal 241, @image.reload.width
    assert_equal 239, @image.height
  end

  test 'generates image versions' do
    process! :image_large_file

    path, ext = @image.image.file.try { |f| [File.dirname(f.path), f.extension] }

    assert File.file? "#{path}/thumbnail.#{ext}"
    assert File.file? "#{path}/preview.#{ext}"
  end

  test 'creates symbolic links for versions larger than source' do
    process! :image_small_file

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