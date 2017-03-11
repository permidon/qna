class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment

  def create
    @comment = current_user.comments.new(body: comment_params[:body], commentable: @commentable)
    if @comment.save
      render json: { comment: @comment }
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_commentable
    commentable_id = params.keys.detect{ |k| k.to_s =~ /.*_id/ }
    model_klass = commentable_id.chomp('_id').classify.constantize
    @commentable = model_klass.find(params[commentable_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      'comments', @comment
    )
  end
end