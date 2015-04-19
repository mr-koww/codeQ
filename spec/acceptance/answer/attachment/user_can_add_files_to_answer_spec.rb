require_relative '../../acceptance_helper'

feature 'User can add files to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I'd like to be able to attach files
} do
  given(:user_question) { create(:user) }
  given(:user_answer) { create(:user) }

  given(:question) { create(:question, user: user_question) }

  given(:file1) { "#{Rails.root}/public/404.html" }
  given!(:file_question) { create(:attachment, attachable: question) }

  background do
    sign_in(user_answer)
    visit question_path(question)
  end

  scenario 'try add one file when write answer', js: true do
    expect {
      fill_in 'answer[body]', with: 'My answer'
      click_on I18n.t('attachment.add')

      file_field = page.find('input[type="file"]')
      file_field.set file1
      click_on I18n.t('answer.create')
    }.to change(Attachment, :count).by(1)

      #within '.answers' do
      #  expect(page).to have_link '404.html', href: '/uploads/attachment/file/1/404.html'
      #end
  end
end