require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = create(:comment_on_image)
  end

  test 'displays comments for given resource' do
    get :index, params: { format: :json,
                          commentable_id: @comment.commentable.id,
                          commentable_type: @comment.commentable.model_name }
    assert_response :success
    assert_equal [@comment.id], json_response.map { |h| h['id'] }
  end

  test 'does not allow a guest user to leave a comment' do

  end

  test 'creates a new comment' do

  end
end
