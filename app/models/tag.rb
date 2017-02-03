# frozen_string_literal: true

class Tag < ApplicationRecord
  self.primary_key = :name

  def self.string_to_names(tag_string)
    tag_string.split(',').reject(&:blank?).map { |name| Tag.sanitize_name(name) }
  end

  def self.sanitize_name(name)
    name.downcase
        .squish
        .gsub(/[\u00b4\u2018\u2019\u201a\u201b\u2032]/, "'") # fancy unicode quotes
        .gsub(/[\u00b4\u201c\u201d\u201e\u201f\u2033]/, '"')
  end
end
