require 'test_helper'

class StarTest < ActiveSupport::TestCase
  setup do
    @resource = create(:image)
    @user = create(:user)
  end

  test 'toggles stars for given resource and user' do
    assert_equal :added, Star.toggle(resource_id: @resource.id, user_id: @user.id)
    assert Star.exists? resource_id: @resource.id, user_id: @user.id

    assert_equal :removed, Star.toggle(resource_id: @resource.id, user_id: @user.id)
    refute Star.exists? resource_id: @resource.id, user_id: @user.id
  end

  test 'updates star count column on resource' do
    assert_difference(->{ @resource.reload.stars }, 1) do
      Star.toggle resource_id: @resource.id, user_id: @user.id
    end
    assert_difference(->{ @resource.reload.stars }, -1) do
      Star.toggle resource_id: @resource.id, user_id: @user.id
    end
  end

  test 'returns resource ids with stars for given user and resource array' do
    resources = [1, 2, 3].map { |id| OpenStruct.new(id: id) }
    resources.each { |res| Star.toggle resource_id: res.id, user_id: @user.id }

    assert_equal [1, 2, 3], Star.resource_ids_with_stars(user: @user, resources: resources)
  end
end
