require_relative '../acceptance_helper'

feature 'User can add files to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I'd like to be able to attach files
} do
  given(:user_question) { create(:user) }
  given(:user_answer) { create(:user) }

  given(:question) { create(:question, user: user_question) }

  background do
    sign_in(user_answer)
    visit question_path(question)
  end

  scenario 'User add file when write answer' do
    fill_in 'Your answer', with: 'My answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    withn '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end