require 'rails_helper'

feature "User can create answer", type: :feature do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  before { sign_in(user) }

  scenario 'with valid data' do
    visit question_path(question)

    fill_in 'Answer', with: answer.body
    click_on 'Add answer'

    expect(page).to have_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario 'with invalid data' do
    visit question_path(question)

    click_on 'Add answer'

    expect(page).to have_content 'Please, check answer data'
  end

end