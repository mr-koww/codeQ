require_relative '../acceptance_helper'

feature 'User can mark best answer', %q{
  In order to be able select best answer for question
  As an author of question
  I'd like to be able mark one of the answers in my question
} do
  # Question
  given(:question) { create(:question, user: user1) }

  # User who had asked Question
  given(:user1) { create(:user) }

  # User who had written 3 answers for question
  given(:user2) { create(:user) }

  # Answer which had written author question
  given(:answer) { create(:answer, question: question, user: user1) }

  # All answers
  given(:answers) { create_list(:answer, 3, question: question, user: user2) }

  describe 'Author question can mark best only for one answer' do
    before do
      answers << answer
      sign_in user1
      visit question_path(question)
    end

    scenario "see link 'Best' for all not his answers" do
      expect(page).to have_link 'Best', count: 3
    end

    scenario 'mark best one of the answer', js: true do
      within "#answer-#{ answers[1].id }" do
        click_on 'Best'
        expect(page).to have_content 'Best answer!', count: 1
      end
    end

    scenario 'mark best another of the answer', js: true do
      within "#answer-#{ answers[1].id }" do
        click_on 'Best'
      end
      within "#answer-#{ answers[2].id }" do
        click_on 'Best'
      end

      within "#answer-#{ answers[1].id }" do
        expect(page).to_not have_content 'Best answer!'
      end

      within "#answer-#{ answers[2].id }" do
        expect(page).to have_content 'Best answer!'
      end

      expect(page).to have_content 'Best answer!', count: 1
    end
  end


  scenario "Not author question doesn't see link 'Best' for question answers" do
    sign_in user2
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end


  scenario "Guest doesn't see link 'Best' for any answers" do
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end
end
