FactoryGirl.define do
  factory :user do
    name { Faker::Hipster.unique.word.gsub(/\+|&|'|\s+/, '') }
    email { Faker::Internet.unique.email }
    password 'password'
  end
end
