require_relative '../../acceptance_helper'

feature 'User can votes for the question', %q{
  In order to like/dislike to the question
  As an authenticated user
  I'd like to be able vote for this question
} do

  given(:user_question) { create(:user) }
  given(:user_who_votes) { create(:user) }

  given(:question) { create(:question, user: user_question) }

  describe 'Auth user tries vote for', js:true do
    context 'not own question' do
      before do
        sign_in(user_who_votes)
        visit question_path(question)
      end

      scenario 'as like' do
        #unvote_link = find(:xpath, "//a[contains(@href,'questions/1/unvote')]")
        click_on 'Like'

        within '.question' do
          expect(page).to have_content '1'
          expect(page).to have_link 'Unvote'
          expect(page).to_not have_link 'Like'
          expect(page).to_not have_link 'Dislike'
        end
      end

      scenario 'as dislike' do
        click_on 'Dislike'

        within '.question' do
          expect(page).to have_content '-1'
          expect(page).to have_link 'Unvote'
          expect(page).to_not have_link 'Like'
          expect(page).to_not have_link 'Dislike'
        end

      end

      scenario 'as unvote' do
        click_on 'Like'
        click_on 'Unvote'

        within '.question' do
          expect(page).to have_content '0'
          expect(page).to have_link 'Like'
          expect(page).to have_link 'Dislike'
          expect(page).to_not have_link 'Unvote'
        end
      end
    end

    context 'own question' do
      scenario 'not see block with vote' do
        sign_in(user_question)
        visit question_path(question)

        within '.question' do
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

      within '.question' do
        expect(page).to_not have_link 'Unvote'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end

    scenario 'see rating for the question' do
      visit question_path(question)

      within '.question' do
        expect(page).to have_content '0'
      end
    end
  end
end