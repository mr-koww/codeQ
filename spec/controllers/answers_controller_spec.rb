require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user_question) { create :user }
  let(:user_answer) { create :user }

  let!(:question) { create :question, user: user_question }
  let!(:answer)   { create :answer, question: question, user: user_answer, best: false }
  let(:file) { create(:attachment, attachable: answer) }

	describe 'POST /create' do
    def request(attributes = {})
      post :create, answer: attributes_for(:answer), question_id: question, format: :js
    end
    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      before { sign_in_user(user_answer) }

      context 'with valid attributes' do
        it_behaves_like 'success response'

        it 'saves answer to database' do
          expect { request }.to change(question.answers, :count).by(1)
        end

        it 'saves the attachment to database' do
          expect { request(attachment: file) }.to change(answer.attachments, :count).by(1)
        end

        it 'should have a user' do
          request
          expect(assigns(:answer).user).to eq subject.current_user
        end

        it 'render create view' do
          request
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'doesn`t save the answer' do
          expect { post :create, answer: { body: nil }, question_id: question, format: :js }.to_not change(Answer, :count)
        end

        it 'render create view' do
          post :create, answer: { body: nil }, question_id: question, format: :js
          expect(response).to render_template :create
        end
      end
    end
  end

  describe 'PATCH /update' do
    def request(attributes = {})
      patch :update, id: answer, answer: { body: 'New answer body' }, question_id: question, format: :js
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'not own answer' do
        before { sign_in_user(user_question) }

        it_behaves_like 'forbidden response'
      end

      context 'own answer' do
        before { sign_in_user(user_answer) }

        context 'with valid attributes' do
          it 'assigns requested answer to @answer' do
            request
            expect(assigns(:answer)).to eq answer
          end

          it 'changes answer attributes' do
            request
            answer.reload
            expect(answer.body).to eq 'New answer body'
          end

          it 'render update view' do
            request
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before { patch :update, id: answer, answer: { body: nil }, format: :js }

          it 'not change answer attributes' do
            answer.reload
            expect(answer.body).to eq answer.body
          end

          it 'render update view' do
            expect(response).to render_template :update
          end
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    def request(attributes = {})
      delete :destroy, id: answer.id, format: :js
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'not own answer' do
        before { sign_in_user(user_question) }

        it_behaves_like 'forbidden response'

        it 'delete the question from the database' do
          expect { request }.to_not change(Answer, :count)
        end
      end

      context 'own answer' do
        before { sign_in_user(user_answer) }

        it 'delete the answer from the database' do
          expect { request }.to change(Answer, :count).by(-1)
        end

        it 'render destroy template' do
          request
          expect(response).to render_template :destroy
        end
      end
    end
  end

  describe 'PATCH /best' do
    def request(attributes = {})
      patch :best, id: answer, question_id: question, format: :js
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'own question' do
        before { sign_in_user(user_question) }
        before { request }

        it 'mark answer to the best' do
          answer.reload
          expect(answer.best).to eq true
        end

        it 'renders best template' do
          expect(response).to render_template :best
        end
      end

      context 'not own question' do
        before { sign_in_user(user_answer) }

        it 'not mark answer to the best' do
          request
          answer.reload
          expect(answer.best).to eq false
        end
      end
    end
  end

  let(:resource) { answer }
  let(:resource_user) { user_answer }
  it_behaves_like 'votable'
end