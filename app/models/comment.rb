class Comment < ApplicationRecord
  COMMENTABLE = %w(Image User).freeze

  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User', inverse_of: :authored_comments

  validates :commentable_type, inclusion: { in: COMMENTABLE }
end
