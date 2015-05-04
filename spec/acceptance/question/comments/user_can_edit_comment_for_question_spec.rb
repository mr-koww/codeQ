require_relative '../../acceptance_helper'

feature 'User can edit/delete comment for question', %q{
  In order to fix mistake
  As an author of comment
  I'd like to be able edit my comment
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:comment) { create(:comment, user: author, commentable: question) }

  scenario 'Non-authenticated user can not see Edit/Delete link' do
    visit question_path(question)

    within '.question_comments' do
      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Authenticated user (not the author) can not see Edit link' do
    sign_in(user)
    visit question_path(question)

    within '.question_comments' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Author can edit his comment', js: true, data: { type: :json } do
    sign_in(author)
    visit question_path(question)

    within '.question_comments' do
      click_on 'Edit'
      fill_in 'comment_body', with: 'Edited comment'
      click_on 'Save'

      expect(page).to_not have_content 'Edited comment'
    end
  end

  scenario 'Author can delete his comment', js: true, data: { type: :json } do
    sign_in(author)
    visit question_path(question)

    within '.question_comments' do
      click_on 'Delete'

      expect(page).to_not have_content 'Edited comment'
    end
  end

end