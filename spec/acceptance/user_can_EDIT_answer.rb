require_relative 'acceptance_helper'

feature 'User can edit answer', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be able edit my answer
} do
  #User who asked Question
  given(:user) { create(:user) }

  #User who wrote first Answer
  given(:user1) { create(:user) }

  #User who nothing wrote
  given(:user2) { create(:user) }

  given!(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user1) }

  describe 'Auth user try edit his answer' do
    before do
      sign_in user1
      visit question_path(question)
    end

    scenario 'see edit link' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'

      fill_in 'Answer', with: 'Edited answer', :match => :first
      click_on 'Save'

      within '.answers' do
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end


  scenario "Auth user doesn't see edit link for not his answer" do
    sign_in user2
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end


  scenario "Not-auth user doesn't see edit link for all answers" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end