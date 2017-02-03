class Image < ApplicationRecord
  mount_uploader :image, ImageUploader

  before_save :apply_tag_change, if: :tag_names_changed?

  delegate :tags=, :apply_tag_change, to: :tags

  def tags
    @tags ||= Tags.new(self)
  end

  after_reload do
    @tags = nil
  end
end
