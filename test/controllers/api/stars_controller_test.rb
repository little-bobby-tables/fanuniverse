require 'test_helper'

class Api::StarsControllerTest < ActionController::TestCase
  setup do
    @starrable = create(:image)
    @user = create(:user)
  end

  test 'returns forbidden when user cannot interact with the application' do
    post :toggle, params: image_params

    assert_response :forbidden
  end

  test 'returns the current number of stars and interaction status if it succeeds' do
    sign_in @user

    post :toggle, params: image_params
    assert_response :success
    assert_equal 1, json_response['stars']
    assert_equal 'added', json_response['status']

    post :toggle, params: image_params
    assert_response :success
    assert_equal 0, json_response['stars']
    assert_equal 'removed', json_response['status']
  end

  def image_params
    { starrable_type: @starrable.model_name.name, starrable_id: @starrable.id }
  end
end
