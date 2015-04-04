require_relative 'acceptance_helper'

feature 'User can create delete', type: :feature do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question1) { create(:question, user: user1) }
  given!(:answer) { create(:answer, question: question1, user: user1) }
  given(:question2) { create(:question, user: user1) }
  given!(:answers) { create_list(:answer, 5, question: question2) }

  scenario 'Auth user can delete own answer' do
    sign_in(user1)

    visit question_path(question1)
    click_on 'Delete answer'

    expect(current_path).to eq question_path(question1)
    expect(page).to_not have_content answer.body
    expect(page).to have_content 'Your answer was successfully destroyed.'
  end

  scenario 'Auth user cannot delete not own answers' do
    sign_in(user2)

    visit question_path(question1)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'cannot delete not own answers' do
    visit question_path(question1)

    expect(page).to_not have_content 'Delete answer'
  end

end