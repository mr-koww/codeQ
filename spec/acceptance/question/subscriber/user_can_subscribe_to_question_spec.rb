require_relative '../../acceptance_helper'

feature 'User can subscribe to the question', %q{
  In order to subscribe the intresting question
  As an authenticated user
  I'd like to be able create subscribe
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:subscribe) { create(:subscriber, question: question, user: user) }

  describe 'Auth user' do
    background do
      sign_in(user)
    end

    describe 'can subscribe' do
      scenario 'when not subscribed yet' do
        visit question_path(question)
        click_on 'Subscribe'

        expect(page).to have_content 'Subscriber was successfully created.'
      end
    end

    describe 'cannot subscribe' do

      scenario 'when already subscribed' do
        subscribe
        visit question_path(question)

        expect(page).to_not have_content 'Subscribe'
      end
    end

    describe 'can unsubscribe' do
      scenario 'when already subscribed' do
        subscribe
        visit question_path(question)
        click_on 'Unsubscribe'

        expect(page).to have_content 'Subscriber was successfully destroyed.'
      end
    end

    describe 'cannot unsubscribe' do
      scenario 'before subscribed' do
        visit question_path(question)

        expect(page).to_not have_content 'Unsubscribe'
      end
    end
  end

  describe 'Guest' do
    scenario 'cannot see link to subscribe/unsubscribe' do
      visit question_path(question)

      expect(page).to_not have_content 'Subscribe'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end
end