# frozen_string_literal: true
class ImageDuplicateDetectionJob < ApplicationJob
  DUPLICATE_THRESHOLD = 0.76

  queue_as :low

  def perform(id)
    image = Image.find(id)

    duplicates = Image
      .from_cte(:possible_duplicates,
                Image.select(:id, :phash)
                     .where.not(id: image.id)
                     .where('length(phash) = ?', image.phash.length))
      .where('hamming_text(phash, ?) > ?', image.phash, DUPLICATE_THRESHOLD)

    duplicates.each do |d|
      Report.create reportable: image,
                    body: "This image might be a duplicate of ##{d.id}."
    end
  end
end
