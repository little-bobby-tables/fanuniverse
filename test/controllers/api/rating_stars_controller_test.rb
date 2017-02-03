require 'test_helper'

class Api::RatingStarsControllerTest < ActionController::TestCase
  setup do
    @image = create(:image)
    @user = create(:user)
  end

  test 'returns not found for non-existent resource' do
    sign_in @user

    post :toggle, params: { resource_id: 'not_an_id' }

    assert_response :not_found
  end

  test 'returns forbidden when user cannot interact with the application' do
    post :toggle, params: { resource_id: @image.id }

    assert_response :forbidden
  end

  test 'returns the current number of stars if interaction succeeds' do
    sign_in @user

    post :toggle, params: { resource_id: @image.id }
    assert_response :success
    assert_equal 1, json_response['stars']

    post :toggle, params: { resource_id: @image.id }
    assert_response :success
    assert_equal 0, json_response['stars']
  end
end
