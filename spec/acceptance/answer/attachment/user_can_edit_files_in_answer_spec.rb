require_relative '../../acceptance_helper'

feature 'User can change/remove file in answer', %q{
  In order to edit attachment in my answer
  As an author of answer
  I'd like to be able to change/remove file
} do

  given(:user_question) { create(:user) }
  given(:user_answer) { create(:user) }

  given(:question) { create(:question, user: user_question) }
  given(:answer) { create(:answer, question: question, user: user_answer) }
  given!(:file_answer) { create(:attachment, attachable: answer) }

  given(:file1) { "#{Rails.root}/public/422.html" }

  describe 'User which edits own answer' do
    background do
      sign_in(user_answer)
      visit question_path(question)
      click_on I18n.t('answer.button.edit')
    end

    scenario 'tries delete file', js: true do
      within '.answers' do
        click_on I18n.t('attachment.button.delete')
        click_on I18n.t('answer.button.save')

        expect(page).to_not have_link file_answer.file.filename, href: file_answer.file.url
      end
    end

    scenario 'tries change file', js: true do
      within '.answers' do
        click_on I18n.t('attachment.button.delete')
        click_on I18n.t('attachment.button.add')

        field = page.all('input[type="file"]').first
        field.set file1

        click_on I18n.t('answer.button.save')

        expect(page).to have_link '422.html', href: '/uploads/attachment/file/2/422.html'
      end
    end
  end
end