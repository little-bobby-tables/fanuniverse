class ImageTagValidator < ActiveModel::Validator
  def validate(record)
    if record.tag_names.size < 3
      record.errors[:base] << 'There should be at least three tags present.'
    end
    if record.tag_names.none? { |tag| tag.start_with? 'artist:' }
      record.errors[:base] << 'The artist\'s name should be included in tags (e.g. artist:somebody).'
    end
  end
end
