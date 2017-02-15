require 'test_helper'

class Api::StarsControllerTest < ActionController::TestCase
  setup do
    @starrable = create(:image)
    @user = create(:user)
  end

  test 'does not allow logged out users to toggle stars' do
    post :toggle, params: star_params
    refute Star.exists? star_params
  end

  test 'returns the current number of stars and interaction status if it succeeds' do
    sign_in @user

    post :toggle, params: star_params
    assert_response :success
    assert_equal 1, json_response['stars']
    assert_equal 'added', json_response['status']

    post :toggle, params: star_params
    assert_response :success
    assert_equal 0, json_response['stars']
    assert_equal 'removed', json_response['status']
  end

  def star_params
    { starrable_type: @starrable.model_name.name, starrable_id: @starrable.id }
  end
end
