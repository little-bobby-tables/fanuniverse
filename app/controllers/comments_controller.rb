class CommentsController < ApplicationController
  before_action :load_commentable, only: [:index, :create]

  def index
    authorize! :view, @commentable

    comments = relation_for(@commentable)
    comment_listing comments
  end

  def create
    authorize! :comment_on, @commentable

    comments = relation_for(@commentable)
    @comment = comments.new(comment_params)

    if @comment.save
      params[:comment_id] = @comment.id
    else
      flash[:error] = 'Your comment could not be posted.'
    end

    comment_listing comments
  end

  private

  def load_commentable
    type = Comment::COMMENTABLE.detect { |type| params[:commentable_type] == type }
    head :bad_request and return unless type

    @commentable = type.constantize.find(params[:commentable_id])
  end

  def comment_listing(comments)
    comments = paginate(comments)
    respond_to do |format|
      format.html { render partial: 'comments/list', layout: false, locals: { comments: comments } }
      format.json { render json: comments  }
    end
  end

  def relation_for(commentable)
    association_name = commentable.class.reflect_on_all_associations(:has_many)
      .detect { |a| a.options[:as] == :commentable }.name
    commentable.send(association_name)
  end

  def comment_params
    params.require(:comment).permit(:body).merge(author: current_user)
  end
end
