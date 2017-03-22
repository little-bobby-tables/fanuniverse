# frozen_string_literal: true
class Profile < ApplicationRecord
  has_many :comments, as: :commentable, validate: false
end
