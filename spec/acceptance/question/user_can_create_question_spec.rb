require_relative '../acceptance_helper'

feature 'User can create question', %q{
  In order to solve my problem
  As an authenticated user
  I'd like to be able create question
} do
  given(:user) { create(:user) }

  describe 'Auth user try' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'create question with valid data', js: true do
      fill_in 'question[title]', with: 'My question'
      fill_in 'question[body]', with: 'My body text'

      click_on I18n.t('question.button.create')

      expect(page).to have_content I18n.t('question.notice.create.success')
      expect(page).to have_content 'My question'
      expect(page).to have_content 'My body text'
      expect(current_path).to eq question_path(user.questions.last)
    end

    scenario 'create question with invalid data', js: true do
      click_on I18n.t('question.button.create')

      expect(page).to have_content I18n.t('question.notice.create.fail')
      #когда метод render, то пишет что путь /questions
      #expect(current_path).to eq new_question_path
    end
  end

  describe 'Not auth user try' do
    scenario 'create question' do
      visit questions_path

      expect(page).to_not have_content I18n.t('question.button.new')
    end
  end
end