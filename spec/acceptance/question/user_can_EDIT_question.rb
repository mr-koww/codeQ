require_relative '../acceptance_helper'

feature 'User can edit question', %q{
  In order to fix mistake
  As an author of question
  I'd like to be able edit my question
} do
  #User who asked Question
  given(:user1) { create(:user) }

  #User who not asked Question
  given(:user2) { create(:user) }

  given!(:question) { create(:question, user: user1) }

  describe 'Auth user try edit his question' do
    before do
      sign_in user1
      visit question_path(question)
    end

    scenario 'see edit link' do
      expect(page).to have_link 'Edit'
    end

    scenario 'try to edit his question', js: true do
      click_on 'Edit'

      fill_in 'Question', with: 'Edited question', :match => :first
      click_on 'Save'

      expect(page).to have_content 'Edited question'
      within '.question' do
        expect(page).to_not have_selector 'textarea'
      end
    end
  end


  scenario "Auth user doesn't see edit link for not his question" do
    sign_in user2
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


  scenario "Not-auth user doesn't see edit link for question" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
