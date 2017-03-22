# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    factory :comment_on_image do
      body { Faker::Hipster.paragraph }
      association :author, factory: :user
      association :commentable, factory: :image
    end
  end
end
