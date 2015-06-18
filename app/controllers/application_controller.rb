require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def render_json(status, type, notice = "", data = "")
    render json: { type: type, data: data, notice: notice }, status: status
  end

  rescue_from CanCan::AccessDenied do |exception|
    render nothing: true, status: :forbidden
    #redirect_to root_url, alert: exception.message
  end

  check_authorization unless: :devise_controller?
end
