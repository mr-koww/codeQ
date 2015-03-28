require 'rails_helper'

feature 'User can sign out', type: :feature do
  given(:user) { create(:user) }

  scenario 'registered user try to sign out' do
    sign_in user

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end