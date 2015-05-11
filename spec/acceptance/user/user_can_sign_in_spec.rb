require_relative '../acceptance_helper'

feature 'User can sign in', type: :feature do
  given!(:user) { create(:user) }

  scenario 'registered' do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'not registered' do
    visit new_user_session_path

    fill_in 'Email', with: 'user'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end
end