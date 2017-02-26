class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable

    if current_user.author_of?(@attachable)
      @attachment.destroy
      flash[:notice] ='The attachment has been successfully deleted.'
    else
      flash[:alert] ='You can not delete this attachment.'
    end
  end
end
