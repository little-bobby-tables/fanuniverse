class ImageTagValidator < ActiveModel::Validator
  def validate(record)
    if record.tag_names.size < 2
      record.errors[:base] <<
        'Please enter at least two tags.'
    end
    if (record.tag_names & %w(safe nsfw)).none?
      record.errors[:base] <<
        'Please specify image rating (safe or nsfw).'
    end
    if (record.tag_names & %w(safe nsfw)).size > 1
      record.errors[:base] <<
        'An image cannot have safe and nsfw tags simultaneously.'
    end
  end
end
