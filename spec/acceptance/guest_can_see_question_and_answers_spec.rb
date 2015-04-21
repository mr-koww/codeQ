require_relative 'acceptance_helper'

feature 'Guest can see question and answers', %q{
  In order to find answer for my question
  As an guest
  I want to be able see all answers for found questions
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario 'Guest can see question and answers thereto' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end