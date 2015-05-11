require_relative '../acceptance_helper'

feature 'User can change email', %q{
  In order to get notifications to my email
  As an user
  I'd like to be able change my email
} do

  given!(:user) { create(:user) }
  given(:another_user) { create(:user) }

  describe 'User tries' do
    before do
      user.confirm!
      sign_in(user)
      visit user_path(user)
    end

    scenario 'change the email to another his own' do
      fill_in 'user[email]', with: 'another@mail.com'
      click_on 'Change'

      expect(page).to have_content I18n.t('devise.confirmations.send_instructions')
    end

    scenario 'change the email to the empty' do
      fill_in 'user[email]', with: ''
      click_on 'Change'

      expect(page).to have_content I18n.t('users.email.notice.change.empty')
    end

    scenario 'change the email to another which busy' do
      fill_in 'user[email]', with: another_user.email
      click_on 'Change'

      expect(page).to have_content I18n.t('users.email.notice.change.busy')
    end

    scenario 'change the email to the same' do
      fill_in 'user[email]', with: user.email
      click_on 'Change'

      expect(page).to have_content I18n.t('users.email.notice.change.same')
    end

    scenario 'change the email to the bad email format' do
      fill_in 'user[email]', with: '12345'
      click_on 'Change'

      expect(page).to have_content I18n.t('users.email.notice.change.fail')
    end

  end
end

