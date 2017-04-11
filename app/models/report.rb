# frozen_string_literal: true
class Report < ApplicationRecord
  REPORTABLE = %w(Image).freeze

  belongs_to :reportable, polymorphic: true
  belongs_to :reported_by, class_name: 'User'
  belongs_to :resolved_by, class_name: 'User'

  validates :body, presence: { message: 'should not be blank.' }
  validates :resolved_by, presence: true, if: :resolved?
end