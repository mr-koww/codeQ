class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :author_attachment?

  respond_to :js, :json

  def destroy
    @attachment.destroy
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def author_attachment?
    render nothing: true, status: :forbidden unless @attachment.attachable.user_id == current_user.id
  end
end