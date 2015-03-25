require 'rails_helper'

feature 'Users', type: :feature do
  given(:user) { create(:user) }
  given(:new_user) { build(:user) }

  scenario 'guest can register' do
    visit root_path
    click_on 'Sign up'

    fill_in 'Email', with: new_user.email
    fill_in 'Password', with: new_user.password
    fill_in 'Password confirmation', with: new_user.password
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'registered user try to sign in' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'registered user try to sign in' do
    sign_in user
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'not-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456789'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end
end