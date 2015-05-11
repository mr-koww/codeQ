class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    sign_in_oauth('Facebook')
  end

  def github
    sign_in_oauth('Github')
  end

  def twitter
    sign_in_oauth('Twitter')
  end

  private

  def sign_in_oauth(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      flash[:alert] = 'Something went wrong. Try a different login method.'
      redirect_to new_user_session_path
    end
  end
end