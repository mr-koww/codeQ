require 'rails_helper'

feature "Answers", type: :feature do

given(:user1) { create(:user) }
given(:user2) { create(:user) }
given(:question) { create(:question, user: user1) }
given(:answer) { create(:answer, user: user1) }
given(:answers) { create_list(:answer, 5) }

describe 'Auth user' do
  scenario 'can creates answer' do
    sign_in(user1)
    visit question_path(question)

    fill_in 'Answer', with: answer.body
    click_on 'Add answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content answer.body
  end

  scenario 'can delete own answers' do
    sign_in(user1)
    question.answers << answer

    visit question_path(question)
    click_on 'Delete answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Your answer was successfully destroyed.'
    expect(page).to_not have_content answer.body
  end

  scenario 'cannot delete not own answers' do
    sign_in(user2)
    question.answers << answer

    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end


describe 'Not-auth user' do
  scenario 'cannot create answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Add answer'
  end

  scenario 'can see all answers in question' do
    question.answers << answers
    visit question_path(question)

    answers.each { |answer| expect(page).to have_content answer.body }
  end
end

end