require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user_question) { create(:user) }
  let(:user) { create(:user) }

  let(:question) { create(:question, user: user_question) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE /destroy' do
    def request(attributes = {})
      delete :destroy, id: attachment, format: :js
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'own attachment' do
        before { sign_in_user(user_question) }

        it 'deletes attachment from database' do
          expect { request }.to change(Attachment, :count).by(-1)
        end

        it 'renders destroy template' do
          request
          expect(response).to render_template :destroy
        end
      end

      context 'not own attachment' do
        before { sign_in_user(user) }

        it_behaves_like 'forbidden response'

        it 'not deletes attachment from database' do
          expect { delete :destroy, id: attachment, format: :js }.to change(Attachment, :count).by(0)
        end
      end
    end
  end
end