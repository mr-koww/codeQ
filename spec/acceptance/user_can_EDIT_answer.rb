require_relative 'acceptance_helper'

feature 'User can edit answer', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be able edit my answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }


  scenario 'Not-auth user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


  describe 'Auth user' do
    before do
      sign_in user
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

    scenario 'try to edit not his answer' do

    end
  end
end