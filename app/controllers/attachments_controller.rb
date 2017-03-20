class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment
  before_action :check_owner

  respond_to :js

  authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable
  end

  def check_owner
    unless current_user.author_of?(@attachable)
      flash[:error] = 'You have no permission to do this action'
      redirect_to questions_path
    end
  end
end
