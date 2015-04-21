require_relative '../acceptance_helper'

feature 'User can delete question', %q{
  In order to remove previously published question
  As an author of question
  I'd like to be able delete my question
} do
  given(:user_question) { create(:user) }
  given(:user_another) { create(:user) }

  given(:question) { create(:question, user: user_question) }

  describe 'Auth user can', js: true do
    before do
      sign_in(user_question)
      visit question_path(question)
    end

    scenario 'delete own question', js: true do
      accept_confirm do
        click_on I18n.t('question.button.delete')
      end

      expect(current_path).to eq questions_path
      expect(page).to have_content I18n.t('question.notice.delete.success')
      expect(page).to_not have_content question.body
    end
  end


  scenario 'Auth user cannot delete not own question' do
    sign_in(user_another)

    visit question_path(question)
    expect(page).to_not have_content I18n.t('question.button.delete')
  end


  scenario 'Guest cannot delete any question' do
    visit question_path(question)

    expect(page).to_not have_content I18n.t('question.button.delete')
  end

end