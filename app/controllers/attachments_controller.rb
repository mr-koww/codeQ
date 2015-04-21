class AttachmentsController < ApplicationController

  before_action :load_attachment
  before_action :authenticate_user!
  before_action :check_access

  def destroy
    @attachment.destroy
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def check_access
    if @attachment.attachable.user_id != current_user.id
      render text: 'You don\'t have permission to view this page.', status: :forbidden
    end
  end

end