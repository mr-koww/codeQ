require_relative '../acceptance_helper'

feature 'User can delete answer', %q{
  In order to remove previously published answer
  As an author of answer
  I'd like to be able delete my answer
} do
  given(:user_question) { create(:user) }
  given(:user_answer) { create(:user) }
  given(:user_another) { create(:user) }

  given(:question1) { create(:question, user: user_question) }
  given(:question2) { create(:question, user: user_question) }

  given!(:answer) { create(:answer, question: question1, user: user_answer) }
  given!(:answers) { create_list(:answer, 5, question: question2, user: user_another) }

  describe 'Auth user can', js: true do
    before do
      sign_in(user_answer)
      visit question_path(question1)
    end

    scenario 'delete own answer', js: true do
      accept_confirm do
        click_on I18n.t('answer.button.delete')
      end

      expect(current_path).to eq question_path(question1)
      expect(page).to_not have_content answer.body
      expect(page).to have_content I18n.t('answer.notice.delete.success')
    end
  end

  scenario 'Auth user cannot delete not own answer' do
    sign_in(user_answer)

    visit question_path(question2)

    expect(page).to_not have_content I18n.t('answer.button.delete')
  end

  scenario 'Guest cannot delete any answer' do
    visit question_path(question1)

    expect(page).to_not have_content I18n.t('answer.button.delete')
  end
end
