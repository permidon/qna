class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment

  respond_to :js

  def destroy
    if current_user.author_of?(@attachable)
      respond_with(@attachment.destroy)
    end
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable
  end
end
