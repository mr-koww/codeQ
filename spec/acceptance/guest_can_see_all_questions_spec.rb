require_relative 'acceptance_helper'

feature 'Guest can see all questions', %q{
  In order to find answer for my question
  As an guest
  I want to be able see all questions
} do
  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }

  scenario 'Guest can see all questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end

end