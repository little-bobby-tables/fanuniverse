FactoryGirl.define do
  factory :user do
    name { Faker::Hipster.word }
    email { Faker::Internet.unique.email }
    password 'password'
  end
end
