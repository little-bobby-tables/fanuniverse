# frozen_string_literal: true
FactoryGirl.define do
  factory :image do
    tags 'artist:somebody, test, test image'
    source 'https://artist.tumblr.com/post/123'
    association :suggested_by, factory: :user

    image { File.open Rails.root.join('test', 'fixtures', 'images', 'small.jpg') }

    factory :image_large_png do
      image { File.open Rails.root.join('test', 'fixtures', 'images', 'large.png') }
    end

    factory :image_gif do
      image { File.open Rails.root.join('test', 'fixtures', 'images', 'animated.gif') }
    end
  end
end
