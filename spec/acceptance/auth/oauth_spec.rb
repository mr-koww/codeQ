require_relative '../acceptance_helper'

feature 'User can authentication through OAuth', %q{
  In order to get access to additional features
  As an guest
  I'd like to be able authentication via OAuth providers
} do

  describe 'when provider is' do
    facebook_mock

    scenario 'Facebook' do
      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(current_path).to eq root_path
      expect(page).to have_content I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook')
    end

end