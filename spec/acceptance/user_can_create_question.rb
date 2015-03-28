require 'rails_helper'

feature "User can create question", type: :feature do
  given(:user) { create(:user) }
  before { sign_in(user) }

  scenario 'with valid data' do
    visit new_question_path

    fill_in 'Title', with: 'Question title with valid data'
    fill_in 'Body', with: 'Question body with valid data'

    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Question title with valid data'
    expect(page).to have_content 'Question body with valid data'
    expect(current_path).to eq question_path(user.questions.last)
  end

  scenario 'with invalid data' do
    visit new_question_path

    click_on 'Create'

    expect(page).to have_content 'Please, check input data'
    #когда метод render пишет что путь /questions
    #expect(current_path).to eq new_question_path
  end
end