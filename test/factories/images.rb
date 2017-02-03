FactoryGirl.define do
  factory :image do
    tags 'safe, test, test image'
    association :suggested_by, factory: :user
  end
end
