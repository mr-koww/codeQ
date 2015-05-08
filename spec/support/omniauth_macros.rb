module OmniauthMacros
  def facebook_mock
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid: '123545',
        info: {
          email: 'email@email.ru'
        }
    })
  end

end