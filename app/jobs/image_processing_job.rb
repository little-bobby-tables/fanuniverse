class ImageProcessingJob < ApplicationJob
  queue_as :image_processing

  def perform(id)
    image = Image.find(id)

    ImageProcessor.new(image).process!

    image.reload.processed = true
    image.save!
  end
end
