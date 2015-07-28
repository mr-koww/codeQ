require 'rails_helper'

describe QuestionsController, type: :controller do
  let(:user_question) { create :user }
  let(:question) { create :question, user: user_question }
  let(:another_user) { create :user }

  describe 'GET /index' do
    let!(:questions) { create_list(:question, 2, user: user_question) }
    before { get :index }

    it 'contains an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET /show' do
    before { get :show, id: question }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET /new' do
    let(:request) { get :new }

    it_behaves_like 'redirect not auth user to login form'

    context 'auth user' do
      before do
        sign_in_user(user_question)
        request
      end

      it 'assigns a new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new template' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET /edit' do
    def request(_attr = {})
      get :edit, id: question
    end

    it_behaves_like 'redirect not auth user to login form'

    context 'auth user' do
      before do
        sign_in_user(user_question)
        request
      end

      it 'assigns requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'redirects to edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST /create' do
    let(:channel) { '/questions' }
    let(:file) { create(:attachment) }
    def request(attr = {})
      post :create, { question: attributes_for(:question) }.merge(attr)
    end

    it_behaves_like 'redirect not auth user to login form'

    context 'auth user' do
      before { sign_in_user(user_question) }

      context 'with valid attributes' do
        it 'saves the new question in database' do
          expect { request }.to change(Question, :count).by(1)
        end

        it 'subscribe author question to the question' do
          expect { request }.to change(subject.current_user.subscribers, :count).by(1)
        end

        it 'saves the attachment in database' do
          expect { request(attachment: file) }.to change(Attachment, :count).by(1)
        end

        it 'should have the user' do
          request
          expect(assigns(:question).user).to eq subject.current_user
        end

        it 'redirects to show view' do
          request
          expect(response).to redirect_to question_path(assigns(:question))
        end

        it_behaves_like 'publishable'
      end

      context 'with invalid attributes' do
        def bad_request(_attr = {})
          post :create, question: attributes_for(:invalid_question)
        end
        it 'does not save question' do
          expect { bad_request }.to_not change(Question, :count)
        end

        it 'render new view' do
          bad_request
          expect(response).to render_template :new
        end

        it_behaves_like 'not publishable'
      end
    end
  end

  describe 'PATCH /update' do
    def request(attr = {})
      patch :update, { id: question, question: { title: 'new default title', body: 'new default body' }, format: :js }.merge(attr)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'not own question' do
        before { sign_in_user(another_user) }

        it_behaves_like 'forbidden response'

        it 'does not change question attributes' do
          old_question = question
          question.reload
          expect(question.title).to eq old_question.title
          expect(question.body).to eq old_question.body
        end
      end

      context 'own question' do
        before { sign_in_user(user_question) }
        before { request }

        context 'with valid attributes' do
          it 'assigns requested question to @question' do
            expect(assigns(:question)).to eq question
          end

          it 'changes question attributes' do
            question.reload
            expect(question.title).to eq 'new default title'
            expect(question.body).to eq 'new default body'
          end
        end

        context 'with invalid attributes' do
          before { patch :update, id: question, question: { title: 'new title', body: nil }, format: :js }

          it 'does not change question attributes' do
            old_question = question
            question.reload
            expect(question.title).to eq old_question.title
            expect(question.body).to eq old_question.body
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    def request(attr = {})
      delete :destroy, { id: question }.merge(attr)
    end

    it_behaves_like 'redirect not auth user to login form'

    context 'auth user' do
      before { question }

      context 'for not own question' do
        before { sign_in_user(another_user) }

        it_behaves_like 'forbidden response'

        it 'not deletes the question from the database' do
          expect { delete :destroy, id: question }.to_not change(Question, :count)
        end
      end

      context 'for own question' do
        before { sign_in_user(user_question) }

        it 'deletes the question from the database' do
          expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
        end
      end
    end
  end

  let(:resource) { question }
  let(:resource_user) { user_question }
  it_behaves_like 'voted'
end