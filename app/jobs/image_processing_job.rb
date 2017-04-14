# frozen_string_literal: true
class ImageProcessingJob < ApplicationJob
  queue_as :image_processing

  def perform(id)
    image = Image.find(id)

    ImageProcessor.new(image).process!

    ImageDuplicateDetectionJob.perform_later(image.id)

    image.reload.processed = true
    image.save!
  end
end
