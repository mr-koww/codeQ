require_relative 'acceptance_helper'

feature 'User can sign out', type: :feature do
  given(:user) { create(:user) }

  scenario 'registered user try to sign out' do
    sign_in user

    click_on 'Sign out'
    visit new_user_session_path

    expect(page).to have_content 'Email'
    expect(page).to have_content 'Password'
    expect(page).to have_content 'Log in'
  end
end