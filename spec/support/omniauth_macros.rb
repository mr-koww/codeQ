module OmniauthMacros
  def facebook_mock
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        provider: 'facebook',
        uid: '12345',
        info: {
          email: 'email@email.ru'
        }
    })
  end

  def github_mock
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
        provider: 'github',
        uid: '12345',
        info: {
          email: ''
        }
    })
  end


end