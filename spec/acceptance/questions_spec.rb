require 'rails_helper'

feature "Questions", type: :feature do

given(:user1) { create(:user) }
given(:user2) { create(:user) }
given(:question) { create(:question, user: user1) }
given(:questions) { create_list(:question, 5) }

describe 'Auth user' do
  scenario 'can creates question' do
    sign_in(user1)
    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'Test Question'
    fill_in 'Body', with: 'Test Default Big Body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'can delete own question' do
    sign_in(user1)
    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Your question was successfully destroyed.'
    expect(current_path).to eq questions_path
  end

  scenario 'cannot delete not own question' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end


describe 'Not-auth user' do
  scenario 'cannot create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'can show all questions' do
    questions
    visit questions_path
    questions.each { |question| expect(page).to have_content question.title }
  end
end

end

