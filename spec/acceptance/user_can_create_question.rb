require 'rails_helper'

feature 'User can create question', type: :feature do
  given(:user) { create(:user) }

  scenario 'Auth user create question with valid data' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title with valid data'
    fill_in 'Body', with: 'Question body with valid data'

    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Question title with valid data'
    expect(page).to have_content 'Question body with valid data'
    expect(current_path).to eq question_path(user.questions.last)
  end

  scenario 'Auth user try create question with invalid data' do
    sign_in(user)
    visit new_question_path

    click_on 'Create'

    expect(page).to have_content 'Please, check question data'
    #когда метод render, то пишет что путь /questions
    #expect(current_path).to eq new_question_path
  end

  scenario 'Not auth user cannot create question' do
    visit questions_path

    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to have_content 'Email'
    expect(page).to have_content 'Password'
  end

end