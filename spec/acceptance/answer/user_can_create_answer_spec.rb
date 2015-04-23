require_relative '../acceptance_helper'

feature 'User can create answer', %q{
  In order to answer the question
  As an authenticated user
  I'd like to be able create answer
} do
  given(:user_question) { create(:user) }
  given(:user_answer) { create(:user) }

  given(:question) { create(:question, user: user_question) }

  describe 'Auth user try' do
    before { sign_in(user_answer) }

    scenario 'create answer with valid data', js: true do
      visit question_path(question)

      fill_in 'answer[body]', with: "My answer"
      click_on I18n.t('answer.button.create')

      within '.answers' do
        expect(page).to have_content "My answer"
      end
      expect(page).to have_content I18n.t('answer.notice.create.success')
      expect(current_path).to eq question_path(question)
    end

    scenario 'with invalid data', js: true, data: { type: :json } do
      visit question_path(question)

      click_on I18n.t('answer.button.create')

      expect(current_path).to eq question_path(question)
      expect(page).to have_content I18n.t('answer.notice.create.fail')
    end
  end

  describe 'Not auth user try' do
    scenario 'create answer' do
      visit question_path(question)

      expect(page).to_not have_content I18n.t('answer.button.new')
    end
  end
end