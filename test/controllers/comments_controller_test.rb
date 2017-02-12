require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  test 'displays comments for given resource' do
    @comment = create(:comment_on_image)

    get :index, params: { format: :json,
                          commentable_id: @comment.commentable.id,
                          commentable_type: @comment.commentable.model_name }

    assert_response :success
    assert_equal [@comment.id], json_response.map { |h| h['id'] }
  end

  test 'does not allow guest users to post comments' do
    post :create, params: { format: :json,
                            commentable_id: create(:image).id,
                            commentable_type: 'Image',
                            comment: { body: 'Comment' } }

    assert_response :forbidden
  end

  test 'creates a new comment' do
    @user, @image = create(:user), create(:image)
    sign_in @user

    post :create, params: { format: :json,
                            commentable_id: @image.id,
                            commentable_type: 'Image',
                            comment: { body: 'Comment' } }
    assert_response :success
    assert @image.comments.exists? author: @user, body: 'Comment'
  end
end
