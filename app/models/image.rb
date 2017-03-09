class Image < ApplicationRecord
  belongs_to :suggested_by, class_name: 'User'

  has_many :stars, as: :starrable, validate: false
  has_many :comments, as: :commentable, validate: false

  has_paper_trail on: [:update],
                  only: [:tag_names, :source],
                  skip: attribute_names.map(&:to_sym).without(:id, :tag_names, :source)

  mount_uploader :image, ImageUploader

  validates :source, format: { with: URI.regexp(%w(http https)), message: 'should be a valid URL.' }
  validates_with ImageTagValidator, if: proc { |m| m.new_record? || m.tag_names_changed? }

  before_save :apply_tag_change, if: :tag_names_changed?

  after_commit(on: :create) { |m| ImageProcessingJob.perform_later(m.id) }

  delegate :tags=, :apply_tag_change, to: :tags

  def tags
    @tags ||= Tags.new(self)
  end

  after_reload do
    @tags = nil
  end

  def short_source
    URI(source).host rescue nil
  end
end
