FactoryGirl.define do
  factory :user do
    name { Faker::Hipster.unique.word }
    email { Faker::Internet.unique.email }
    password 'password'
  end
end
