class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  respond_to :json

  authorize_resource

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    respond_with(@comment, location: @commentable, status: 200)
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
end