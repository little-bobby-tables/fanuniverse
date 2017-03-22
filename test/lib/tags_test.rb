# frozen_string_literal: true
require 'test_helper'

class TagsTest < ActiveSupport::TestCase
  setup do
    @resource = create(:image)
  end

  test 'addition creates nonexistent tags' do
    @resource.tag_names << 'tag that should be created'
    assert @resource.save
    assert Tag.exists? name: 'tag that should be created'
  end

  test 'update refreshes tag representations' do
    @tag_name = 'pearl'
    @resource.tag_names += [@tag_name]
    @resource.save && @resource.reload
    assert_includes @resource.tag_names, @tag_name
    assert_includes @resource.tags.to_s, @tag_name

    @resource.tag_names -= [@tag_name]
    @resource.save && @resource.reload
    refute_includes @resource.tag_names, @tag_name
    refute_includes @resource.tags.to_s, @tag_name
  end

  test 'should update tag counters' do
    @tag = create(:tag)
    assert_tag_count_difference(1)  { @resource.tag_names += [@tag.name] }
    assert_tag_count_difference(-1) { @resource.tag_names -= [@tag.name] }
  end

  def assert_tag_count_difference(diff)
    assert_difference(-> { @tag.reload.image_count }, diff) { yield && @resource.save }
  end
end
