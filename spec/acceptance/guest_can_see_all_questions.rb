require_relative 'acceptance_helper'

feature "Guest can see all questions", type: :feature do
  given!(:questions) { create_list(:question, 5) }

  scenario 'can show all questions' do
    visit questions_path
    save_and_open_page

    questions.each { |question| expect(page).to have_content question.title }
  end

end