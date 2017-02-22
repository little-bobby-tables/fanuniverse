require 'test_helper'

class ImagesControllerTest < ActionController::TestCase
  include ActiveJob::TestHelper

  setup do
    @image = create(:image_small_file)
    @user = create(:user)
  end

  test 'creates image' do
    sign_in @user

    assert_difference('Image.count') do
      post :create, params: { image: { tags: 'safe, tag',
                                       image: File.open(Rails.root.join('test', 'fixtures', 'images', 'small.jpg')) } }
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

  test 'only displays images that are processed' do
    @images = [@image] + create_list(:image_small_file, 2)
    refresh_index Image

    get :index
    assert_equal [], assigns(:images).to_a

    perform_enqueued_jobs!
    refresh_index Image

    get :index
    assert_equal @images.map(&:id).sort, assigns(:images).map(&:id).sort
  end

  test 'given a query, displays search results' do
    @images = [@image] + create_list(:image_small_file, 2)
    @images.first.update_columns star_count: 10

    perform_enqueued_jobs!
    refresh_index Image

    get :index, params: { q: 'stars: more than 9' }
    assert_equal [@images.first], assigns(:images).to_a
  end

  test 'updates image tags' do
    sign_in @user

    # Tags are compared against tag_cache,
    post :update, params: { id: @image.id, image: { tags: 'safe, tag1, tag2', tag_cache: @image.tags } }
    assert_equal %w(safe tag1 tag2), @image.reload.tag_names.sort

    # ...which controls what tags are added
    post :update, params: { id: @image.id, image: { tags: 'safe, tag1, tag2, tag3, tag4', tag_cache: 'safe, tag1, tag2, tag3' } }
    assert_equal %w(safe tag1 tag2 tag4), @image.reload.tag_names.sort

    # ...and removed
    post :update, params: { id: @image.id, image: { tags: 'safe, tag1', tag_cache: 'safe, tag1, tag4' } }
    assert_equal %w(safe tag1 tag2), @image.reload.tag_names.sort

    # ...and which is required
    post :update, params: { id: @image.id, image: { tags: 'safe, tag1, tag2, tag3, tag4, tag5' } }
    assert_equal %w(safe tag1 tag2), @image.reload.tag_names.sort
  end

  test 'tag changes are recorded, including the user who performed them' do
    sign_in @user

    post :update, params: { id: @image.id, image: { tags: 'safe, tag1, tag2', tag_cache: @image.tags } }
    assert_equal %w(safe tag1 tag2), @image.reload.tag_names.sort

    assert_equal @user.id, @image.versions.last.whodunnit.to_i
  end
end
