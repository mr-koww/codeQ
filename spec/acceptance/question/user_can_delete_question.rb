require_relative '../acceptance_helper'

feature 'User can delete question', %q{
  As an author of question
  I'd like to be able delete my question
} do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user1) }

  describe 'Auth user try delete his question' do
    before do
      sign_in(user1)
      visit question_path(question)
    end

    scenario 'see delete link' do
      expect(page).to have_link 'Delete question'
    end

    scenario 'try to delete his question' do
      click_on 'Delete question'

      expect(current_path).to eq questions_path
      expect(page).to have_content 'Your question was successfully destroyed.'
      expect(page).to_not have_content question.body
    end
  end


  scenario 'Auth user cannot delete not his question' do
    sign_in(user2)

    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end


  scenario 'Guest cannot delete any question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end

end