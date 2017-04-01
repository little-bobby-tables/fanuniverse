# frozen_string_literal: true
require 'test_helper'

class ImageUploaderTest < ActiveSupport::TestCase
  test 'animated?' do
    image = create :image_gif
    assert image.image.animated?

    image = create :image
    refute image.image.animated?
  end
end
