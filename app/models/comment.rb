# frozen_string_literal: true
class Comment < ApplicationRecord
  COMMENTABLE = %w(Image Profile).freeze

  default_scope { order(created_at: :desc) }

  belongs_to :commentable, polymorphic: true, counter_cache: 'comment_count'
  belongs_to :author, class_name: 'User', inverse_of: :authored_comments

  has_many :stars, as: :starrable, validate: false

  validates :body, presence: { message: 'should not be blank.' }
end
