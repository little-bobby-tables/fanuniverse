# frozen_string_literal: true
require 'test_helper'

class ImageDuplicateDetectionJobTest < ActiveJob::TestCase
  test 'detects duplicate images' do
    @image1 = processed :image
    @image2 = processed :image_duplicate

    ImageDuplicateDetectionJob.perform_now @image1.id

    @report = Report.where(reportable: @image1).first

    assert @report.present?
    assert @report.body == "This image might be a duplicate of ##{@image2.id}."
  end

  test 'does not report images that are outright different' do
    processed :image
    processed :image_large_png
    processed :image_gif

    assert Report.none?
  end

  def processed(factory)
    create(factory).tap do |image|
      ImageProcessingJob.perform_now(image.id)
    end
  end
end
