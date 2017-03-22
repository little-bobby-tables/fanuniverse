# frozen_string_literal: true
require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  setup do
    @image = create(:image)
  end

  test 'records tag and source update history' do
    @image.tag_names << 'new tag I just added'
    @image.save

    assert_equal 1, @image.versions.count
    assert_equal @image.previous_changes[:tag_names].first, @image.paper_trail.previous_version.tag_names

    @image.source = 'http://newsour.ce'
    @image.save

    assert_equal 2, @image.versions.count
    assert_equal @image.previous_changes[:source].first, @image.paper_trail.previous_version.source
  end
end
