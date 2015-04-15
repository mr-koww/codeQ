require_relative '../acceptance_helper'

feature 'User can add files to question', %q{
  In order to illustrate my question
  As an author of question
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario '' do
    fill_in 'Title', with: 'My question'
    fill_in 'Body', with: 'My body text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'

  end
end