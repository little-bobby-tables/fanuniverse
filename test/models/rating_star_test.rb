require 'test_helper'

class RatingStarTest < ActiveSupport::TestCase
  setup do
    @resource = create(:image)
    @user = create(:user)
  end

  test 'toggles rating stars for given resource and user' do
    RatingStar.toggle resource_id: @resource.id, user_id: @user.id
    assert RatingStar.exists? resource_id: @resource.id, user_id: @user.id

    RatingStar.toggle resource_id: @resource.id, user_id: @user.id
    refute RatingStar.exists? resource_id: @resource.id, user_id: @user.id
  end

  test 'updates star count column on resource' do
    assert_difference(->{ @resource.reload.stars }, 1) do
      RatingStar.toggle resource_id: @resource.id, user_id: @user.id
    end
    assert_difference(->{ @resource.reload.stars }, -1) do
      RatingStar.toggle resource_id: @resource.id, user_id: @user.id
    end
  end
end
