require_relative '../../acceptance_helper'

feature 'User can add comment for question', %q{
  In order to comments question
  As an authorized user
  I'd like to be able to add comment for question
} do

  given(:question_author) { create(:user) }
  given(:question) { create(:question, user: question_author) }

  given(:user) { create(:user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Creates comment', js: true, data: { type: :json } do
      within '.question' do
        fill_in 'comment_body', with: 'My comment'
        click_on 'Add'

        expect(page).to have_content 'My comment'
      end
    end

    scenario 'Tries to create invalid comment', js: true, data: { type: :json } do
      within '.question' do
        fill_in 'comment_body', with: nil
        click_on 'Add'
      end

      expect(page).to have_content "body can't be blank"
    end
  end

  context 'Non-authenticated user' do
    scenario 'Can not to see link to create comment' do
      expect(page).to_not have_link 'add comment'
    end
  end
end