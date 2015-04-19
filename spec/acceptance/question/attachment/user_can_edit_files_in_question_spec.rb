require_relative '../../acceptance_helper'

feature 'User can change/remove file in question', %q{
  In order to edit attachment in my question
  As an author of question
  I'd like to be able to change/remove file
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:file_question) { create(:attachment, attachable: question) }

  given(:file1) { "#{Rails.root}/public/422.html" }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User try delete file from own question', js: true do
  click_on I18n.t('question.attachments.delete')

  expect(page).to_not have_link file_question.file.filename, href: file_question.file.url
  end

  scenario 'User try change file when edit own question', js: true do
    click_on I18n.t('question.attachments.delete')
    click_on I18n.t('question.edit')

    field = page.all('input[type="file"]').first
    field.set file1

    click_on I18n.t('question.save')

    expect(page).to have_link '422.html', href: '/uploads/attachment/file/2/422.html'
  end
end