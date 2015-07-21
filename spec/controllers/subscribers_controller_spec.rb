require 'rails_helper'

describe SubscribersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:subscriber) { create(:subscriber, question: question, user: user) }

  describe 'POST /create' do
    def request(_attr = {})
      post(:create, question_id: question, format: :js)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      before { sign_in_user(user) }

      context 'when not subscribed' do
        it 'saves new subscriber in database' do
          expect { request }.to change(Subscriber, :count).by(1)
        end

        it 'associates the new subscriber with the question' do
          expect { request }.to change(question.subscribers, :count).by(1)
        end
      end

      context 'when already subscribed' do
        before { subscriber }

        it 'doesnt changes the subscriber in  database' do
          expect { request }.to_not change(Subscriber, :count)
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    def request(_attr = {})
      patch(:destroy, id: subscriber, format: :js)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'own subscribe' do
        before { sign_in_user(user) }

        it 'deletes subscriber from the database' do
          subscriber
          expect { request }.to change(Subscriber, :count).by(-1)
        end
      end

      context 'not own subscribe' do
        before { sign_in_user(author) }

        it_behaves_like 'forbidden response'

        it 'doesnt delete subscriber from the database' do
          subscriber
          expect { request }.to_not change(Subscriber, :count)
        end
      end
    end
  end
end
