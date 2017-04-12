# frozen_string_literal: true
class ImageDuplicateDetectionJob < ApplicationJob
  DUPLICATE_THRESHOLD = 0.76

  queue_as :low

  def perform(id)
    image = Image.find(id)

    Image
      .select(:id)
      .where.not(id: image.id)
      .where('length(phash) = ?', image.phash.length)
      .where('hamming_text(phash, ?) > ?', image.phash, DUPLICATE_THRESHOLD)
      .find_each do |duplicate|

      Report.create reportable: image,
                    body: "This image might be a duplicate of ##{duplicate.id}."
    end
  end
end
