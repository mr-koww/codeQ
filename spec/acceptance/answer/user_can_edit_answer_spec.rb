require_relative '../acceptance_helper'

feature 'User can edit answer', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be able edit my answer
} do
  given(:user_question) { create(:user) }
  given(:user_answer) { create(:user) }
  given(:user_another) { create(:user) }

  given!(:question) { create(:question, user: user_question) }
  given!(:answer) { create(:answer, question: question, user: user_answer) }

  describe 'Auth user can' do
    before do
      sign_in user_answer
      visit question_path(question)
    end

    scenario 'edit own answer with valid data', js: true do
      within '.answers' do
        click_on I18n.t('answer.button.edit')

        fill_in 'answer[body]', with: 'Another body text'
        click_on I18n.t('answer.button.save')

        expect(page).to have_content 'Another body text'
        expect(page).to_not have_selector 'textarea'
      end
      expect(page).to have_content I18n.t('answer.notice.update.success')
    end

    scenario 'edit own answer with invalid data', js: true do
      within '.answers' do
        click_on I18n.t('answer.button.edit')

        fill_in 'answer[body]', with: nil
        click_on I18n.t('answer.button.save')
      end

      expect(page).to have_content I18n.t('answer.notice.update.fail')
    end
  end

  scenario "Auth user doesn't see edit link for not his answer" do
    sign_in user_question
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link I18n.t('answer.button.save')
    end

  end

  scenario "Not-auth user doesn't see edit link for all answers" do
    visit question_path(question)

    expect(page).to_not have_link I18n.t('answer.button.save')
  end
end
