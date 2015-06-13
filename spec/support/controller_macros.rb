module ControllerMacros
  def sign_in_user(user)
    @user = user
    @user.confirmed_at = Time.now
    @user.save
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
  end
end