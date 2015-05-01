require_relative '../../acceptance_helper'

feature 'User can votes for the answer', %q{
  In order to like/dislike to the answer
  As an authenticated user
  I'd like to be able vote for this answer
} do

  given(:user_question) { create(:user) }
  given(:user_answer) { create(:user) }

  given(:question) { create(:question, user: user_question) }
  given!(:answer) { create(:answer, question: question, user: user_answer) }

  describe 'Auth user tries vote for', js:true do
    context 'not own answer' do
      before do
        sign_in(user_question)
        visit question_path(question)
      end

      scenario 'as like' do
        within '.answers' do
          click_on 'Like'

          expect(page).to have_content '1'
          expect(page).to have_link 'Unvote'
          expect(page).to_not have_link 'Like'
          expect(page).to_not have_link 'Dislike'
        end
      end

      scenario 'as dislike' do
        within '.answers' do
          click_on 'Dislike'

          expect(page).to have_content '-1'
          expect(page).to have_link 'Unvote'
          expect(page).to_not have_link 'Like'
          expect(page).to_not have_link 'Dislike'
        end

      end

      scenario 'as unvote' do
        within '.answers' do
          click_on 'Like'
          click_on 'Unvote'

          expect(page).to have_content '0'
          expect(page).to have_link 'Like'
          expect(page).to have_link 'Dislike'
          expect(page).to_not have_link 'Unvote'
        end
      end
    end

    context 'own answer' do
      scenario 'not see block with vote' do
        sign_in(user_answer)
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_link 'Unvote'
          expect(page).to_not have_link 'Like'
          expect(page).to_not have_link 'Dislike'
        end
      end
    end
  end

  describe 'Guest' do
    scenario 'not see link to vote' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Unvote'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end

    scenario 'see rating for the answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content '0'
      end
    end
  end
end