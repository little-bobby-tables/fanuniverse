# frozen_string_literal: true
FactoryGirl.define do
  factory :report do
    factory :report_on_image do
      body { Faker::Hipster.paragraph }
      association :reportable, factory: :image
      association :reported_by, factory: :user
    end
  end
end
