FactoryGirl.define do
  factory :image do
    tags 'artist:somebody, test, test image'
    association :suggested_by, factory: :user

    factory :image_small_file do
      image { File.open Rails.root.join('test', 'fixtures', 'images', 'small.jpg') }
    end

    factory :image_large_file do
      image { File.open Rails.root.join('test', 'fixtures', 'images', 'large.png') }
    end
  end
end
