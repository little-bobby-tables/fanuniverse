class Image < ApplicationRecord
  belongs_to :suggested_by, class_name: 'User'

  has_many :stars, as: :starrable, validate: false
  has_many :comments, as: :commentable, validate: false

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
