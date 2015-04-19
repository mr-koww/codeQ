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
  given(:file2) { "#{Rails.root}/public/422.html" }

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
      sleep(1)
    }.to change(Attachment, :count).by(1)

    within '.answers' do
      expect(page).to have_link '404.html', href: '/uploads/attachment/file/1/404.html'
    end
  end

  scenario 'try add a few files when write answer', js: true do
    expect {
      fill_in 'answer[body]', with: 'My answer'

      click_on I18n.t('attachment.add')

      file_field1 = page.find('input[type="file"]')
      file_field1.set file1

      click_on I18n.t('attachment.add')
      file_field2 = page.all('input[type="file"]').last
      file_field2.set file2

      click_on I18n.t('answer.create')
      sleep(1)
    }.to change(Attachment, :count).by(2)

    within '.answers' do
      expect(page).to have_link '404.html', href: '/uploads/attachment/file/1/404.html'
      expect(page).to have_link '422.html', href: '/uploads/attachment/file/2/422.html'
    end
  end

  scenario 'try write answer with empty attachment', js: true do
    expect{
      fill_in 'answer[body]', with: 'My answer'

      click_on I18n.t('attachment.add')
      click_on I18n.t('answer.create')
      sleep(1)
    }.to change(Answer, :count).by(1)

    expect(page).to have_content 'My answer'
  end
end