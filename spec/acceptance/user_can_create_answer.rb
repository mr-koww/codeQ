require 'rails_helper'

feature 'User can create answer', type: :feature do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  before { sign_in(user) }

  scenario 'with valid data', js: true do
    visit question_path(question)

    fill_in 'Your answer', with: answer.body
    click_on 'Add answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content answer.body
    end
  end

  scenario 'with invalid data', js: true do
    visit question_path(question)

    click_on 'Add answer'

    expect(current_path).to eq question_path(question)
  end

end