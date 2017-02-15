class Comment < ApplicationRecord
  COMMENTABLE = %w(Image User).freeze

  default_scope { order(created_at: :desc) }

  belongs_to :commentable, polymorphic: true, counter_cache: 'comment_count'
  belongs_to :author, class_name: 'User', inverse_of: :authored_comments

  has_many :stars, as: :starrable, validate: false

  validates :commentable_type, inclusion: { in: COMMENTABLE }
end
