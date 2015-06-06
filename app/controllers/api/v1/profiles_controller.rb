class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource :user

  def index
    users = User.where.not(id: current_resource_owner.id)
    respond_with users
  end

  def me
    respond_with current_resource_owner
  end
end