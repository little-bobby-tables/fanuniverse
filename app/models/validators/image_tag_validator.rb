class ImageTagValidator < ActiveModel::Validator
  def validate(record)
    if record.tag_names.size < 3
      record.errors[:base] << 'Please enter at least three tags.'
    end
    if record.tag_names.none? { |tag| tag.start_with? 'artist:' }
      record.errors[:base] << 'Please include the artist name in tags (e.g. artist:somebody).'
    end
  end
end
