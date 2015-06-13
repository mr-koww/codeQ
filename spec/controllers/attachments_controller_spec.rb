require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user_question) { create(:user) }
  let(:user_answer) { create(:user) }
  # User who not written anything
  let(:user_another) { create(:user) }

  let(:question) { create(:question, user: user_question) }
  let(:file_question) { create(:attachment, attachable: question) }

  let(:answer) { create(:answer, user: user_answer, question: question) }
  let(:file_answer) { create(:attachment, attachable: answer) }

  describe 'DELETE #destroy' do
    describe 'Question attachment delete' do
      context 'User try delete attachment for his question' do
        before do
          sign_in_user(user_question)
          file_question
        end

        it 'deletes attachment from database' do
          expect { delete :destroy, id: file_question, format: :js }.to change(Attachment, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, id: file_question, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'User try delete attachment for not his question' do
        before do
          sign_in_user(user_another)
          file_question
        end

        it 'not deletes attachment from database' do
          expect { delete :destroy, id: file_question, format: :js }.to change(Attachment, :count).by(0)
        end

        it 'render forbidden response' do
          delete :destroy, id: file_question, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'Guest try delete attachment for question' do
        before do
          file_question
        end

        it 'not deletes attachment from database' do
          expect { delete :destroy, id: file_question, format: :js }.to change(Attachment, :count).by(0)
        end

        it 'render unauthorized response' do
          delete :destroy, id: file_question, format: :js
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe 'Answer attachment delete' do
      context 'User try delete attachment for his answer' do
        before do
          sign_in_user(user_answer)
          file_answer
        end

        it 'deletes attachment from database' do
          expect { delete :destroy, id: file_answer, format: :js }.to change(Attachment, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, id: file_answer, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'User try delete attachment for not his answer' do
        before do
          sign_in_user(user_another)
          file_answer
        end

        it 'not deletes attachment from database' do
          expect { delete :destroy, id: file_answer, format: :js }.to change(Attachment, :count).by(0)
        end

        it 'render forbidden response' do
          delete :destroy, id: file_answer, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'Guest try delete attachment for answer' do
        before do
          file_answer
        end

        it 'not deletes attachment from database' do
          expect { delete :destroy, id: file_answer, format: :js }.to change(Attachment, :count).by(0)
        end

        it 'render unauthorized response' do
          delete :destroy, id: file_answer, format: :js
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end