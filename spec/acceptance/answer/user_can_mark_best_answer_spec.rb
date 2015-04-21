require_relative '../acceptance_helper'

feature 'User can mark best answer', %q{
  In order to be able choose answer which solves my problem
  As an author of question
  I'd like to be able mark bestt one of the answers in my question
} do
  given(:user_question) { create(:user) }
  #given(:user_answer) { create(:user) }
  given(:user_answers) { create(:user) }
  given(:user_another) { create(:user) }

  given(:question) { create(:question, user: user_question) }
  #given(:answer) { create(:answer, question: question, user: user_answer) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user_answers) }

  describe 'Author question can' do
    before do
      sign_in user_question
      visit question_path(question)
    end

    scenario 'mark best one of the answer', js: true do
      within "#answer-#{ answers[1].id }" do
        click_on I18n.t('answer.button.best')
      end

      within ".answers" do
        expect(page).to have_content I18n.t('answer.label.best'), count: 1
      end
    end

    scenario 'mark best another of the answer', js: true do
      within "#answer-#{ answers[1].id }" do
        click_on I18n.t('answer.button.best')
      end
      within "#answer-#{ answers[2].id }" do
        click_on I18n.t('answer.button.best')
      end

      within "#answer-#{ answers[1].id }" do
        expect(page).to_not have_content I18n.t('answer.label.best')
      end

      within "#answer-#{ answers[2].id }" do
        expect(page).to have_content I18n.t('answer.label.best')
      end

      expect(page).to have_content I18n.t('answer.label.best'), count: 1
    end
  end


  scenario "Not author question doesn't see link 'Best' for question answers" do
    sign_in user_another
    visit question_path(question)

    expect(page).to_not have_link I18n.t('answer.label.best')
  end


  scenario "Guest doesn't see link 'Best' for any answers" do
    visit question_path(question)

    expect(page).to_not have_link I18n.t('answer.label.best')
  end
end
