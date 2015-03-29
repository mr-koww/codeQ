require 'rails_helper'

feature 'User can delete question', type: :feature do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user1) }

  scenario 'Auth user can delete own question' do
    sign_in(user1)
    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Your question was successfully destroyed.'
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(current_path).to eq questions_path
  end

  scenario 'Auth user cannot delete not own question' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Not-auth user cannot delete any question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end

end