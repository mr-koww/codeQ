require_relative '../../acceptance_helper'

feature 'User can add file/files to question', %q{
  In order to illustrate my question
  As an author of question
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:file1) { "#{Rails.root}/public/404.html" }
  given(:file2) { "#{Rails.root}/public/422.html" }

  describe 'User which asked question' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'try add one file when ask question', js: true do
      fill_in 'question[title]', with: 'My question'
      fill_in 'question[body]', with: 'My body text'

      click_on I18n.t('attachment.button.add')
      file_field = page.find('input[type="file"]')
      file_field.set file1

      click_on I18n.t('question.button.create')

      expect(page).to have_link '404.html', href: '/uploads/attachment/file/1/404.html'
    end

    scenario 'try add a few files when ask question', js: true do
      fill_in 'question[title]', with: 'My question'
      fill_in 'question[body]', with: 'My body text'

      click_on I18n.t('attachment.button.add')
      file_field1 = page.find('input[type="file"]')
      file_field1.set file1

      click_on I18n.t('attachment.button.add')
      file_field2 = page.all('input[type="file"]').last
      file_field2.set file2

      click_on I18n.t('question.button.create')

      expect(page).to have_link '404.html', href: '/uploads/attachment/file/1/404.html'
      expect(page).to have_link '422.html', href: '/uploads/attachment/file/2/422.html'
    end

    scenario 'try ask question with empty attachment', js: true do
      fill_in 'question[title]', with: 'My question'
      fill_in 'question[body]', with: 'My body text'

      click_on I18n.t('attachment.button.add')

      click_on I18n.t('question.button.create')

      expect(page).to have_content 'My question'
      expect(page).to have_content 'My body text'
    end
  end
end