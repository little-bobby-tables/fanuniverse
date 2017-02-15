require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper

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

  test 'displays all images without a query parameter' do
    @images = [@image] + create_list(:image, 2)
    refresh_index Image

    get :index
    assert_equal @images.map(&:id).sort, assigns(:images).map(&:id).sort
  end

  test 'given a query, displays search results' do
    @images = [@image] + create_list(:image, 2)
    perform_enqueued_jobs { @images.first.update_columns star_count: 10 and @images.first.reindex_now }
    refresh_index Image

    get :index, params: { q: 'stars: more than 9' }
    assert_equal [@images.first], assigns(:images).to_a
  end
end
