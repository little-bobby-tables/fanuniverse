require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  setup do
    @image = create(:image)
    @user = create(:user)
  end

  test 'creates image' do
    sign_in @user

    assert_difference('Image.count') do
      post :create, params: { image: { tags: 'tag' } }
    end
    @created_image = Image.last

    assert_equal @user, @created_image.suggested_by
    assert_redirected_to image_url(@created_image)
  end

  test 'shows image' do
    get :show, params: { id: @image.id }
    assert_equal @image, assigns(:image)
    assert_response :success
  end
end
