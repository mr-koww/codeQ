require_relative '../acceptance_helper'

feature 'User can edit question', %q{
  In order to fix mistake
  As an author of question
  I'd like to be able edit my question
} do
  given(:user_question) { create(:user) }
  given(:user_another) { create(:user) }

  given!(:question) { create(:question, user: user_question) }

  describe 'Auth user can' do
    before do
      sign_in user_question
      visit question_path(question)
    end

    scenario 'edit own question with valid data', js: true do
      click_on I18n.t('question.button.edit')

      fill_in 'question[body]', with: 'Another body text'

      click_on I18n.t('question.button.save')

    within '.question' do
      expect(page).to_not have_selector 'textarea'
    end
    expect(page).to have_content 'Another body text'
    end

    scenario 'edit own question with invalid data', js: true do
      click_on I18n.t('question.button.edit')

      fill_in 'question[body]', with: nil

      click_on I18n.t('question.button.save')

      expect(page).to have_content I18n.t('question.notice.update.fail')
    end
  end


  scenario "Auth user doesn't see edit link for not his question" do
    sign_in user_another
    visit question_path(question)

    expect(page).to_not have_link I18n.t('question.button.edit')
  end


  scenario "Not-auth user doesn't see edit link for question" do
    visit question_path(question)

    expect(page).to_not have_link I18n.t('question.button.edit')
  end
end
