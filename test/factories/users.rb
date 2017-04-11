# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    name { Faker::Hipster.unique.word.gsub(/\+|&|'|\s+/, '') }
    email { Faker::Internet.unique.email }
    password 'password'

    factory :user_admin do
      role 'admin'
    end
  end
end
