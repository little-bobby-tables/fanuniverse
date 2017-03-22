# frozen_string_literal: true
class CommentsController < ApplicationController
  before_action :load_commentable, only: [:index, :create]

  def index
    authorize! :view, @commentable

    comment_listing @commentable.comments
  end

  def create
    authorize! :comment_on, @commentable

    @comment = @commentable.comments.new(comment_params)

    if @comment.save
      params[:comment_id] = @comment.id

      comment_listing @commentable.comments
    else
      render partial: 'layouts/errors', locals: { model: @comment }, layout: false, status: :unprocessable_entity
    end
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
      format.json { render json: comments }
    end
  end

  def comment_params
    params.require(:comment).permit(:body).merge(author: current_user)
  end
end
