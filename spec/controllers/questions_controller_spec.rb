require 'rails_helper'

describe QuestionsController, type: :controller do
  let(:user_question) { create :user }
  let(:question) { create :question, user: user_question }
  let(:another_user) { create :user }

  describe 'GET /index' do
    let(:questions) { create_list(:question, 2, user: user_question) }
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
    def request(attribute = {})
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
    let(:file) { create(:attachment) }
    def request(attributes = {})
      post :create, { question: attributes_for(:question) }.merge(attributes)
    end

    it_behaves_like 'redirect not auth user to login form'

    context 'auth user' do
      before { sign_in_user(user_question) }

      context 'with valid attributes' do
        it 'saves the new question in database' do
          expect { request }.to change(Question, :count).by(1)
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
      end

      context 'with invalid attributes' do
        it 'does not save question' do
          expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end

        it 'render new view' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'PATCH /update' do
    def request(attributes = {})
      patch :update, { id: question, question: { title: 'new default title', body: 'new default body' }, format: :js }.merge(attributes)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'not own question' do
        before { sign_in_user(another_user) }

        it_behaves_like 'forbidden response'
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
            question.reload
            expect(question.title).to eq question.title
            expect(question.body).to eq question.body
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    def request(attributes = {})
      delete :destroy, { id: question }.merge(attributes)
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

  describe 'PATCH /like' do
    def request(attributes = {})
      patch :like, { id: question, format: :js }.merge(attributes)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'for own question' do
        before { sign_in_user(user_question) }

        it_behaves_like 'forbidden response'

        it 'isnt increases the question value' do
          request
          question.reload
          expect(question.total_votes).to eq 0
        end

        it 'isnt saves the new vote in the database' do
          expect { request }.to_not change(Vote, :count)
        end
      end

      context 'for not own question' do
        before { sign_in_user(another_user) }

        it 'increases the question value' do
          request
          question.reload
          expect(question.total_votes).to eq 1
        end

        it 'saves the new vote in the database' do
          expect { request }.to change(question.votes, :count).by(1)
        end
      end
    end
  end

  describe 'PATCH /dislike' do
    def request(attributes = {})
      patch :dislike, { id: question, format: :js }.merge(attributes)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'for own question' do
        before { sign_in_user(user_question) }

        it_behaves_like 'forbidden response'

        it 'isnt saves the new vote in the database' do
          expect { request }.to_not change(question.votes, :count)
        end

        it 'isnt increases the question value' do
          request
          question.reload
          expect(question.total_votes).to eq 0
        end
      end

      context 'for not own question' do
        before { sign_in_user(another_user) }

        it 'saves the new vote in the database' do
          expect { request }.to change(question.votes, :count).by(1)
        end

        it 'increases the question value' do
          request
          question.reload
          expect(question.total_votes).to eq -1
        end
      end
    end
  end

  describe 'PATCH /unvote' do
    def request(attributes = {})
      patch :unvote, { id: question, format: :js }.merge(attributes)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      let!(:vote) { create(:vote, votable: question, user: another_user, value: 1) }

      context 'for own question' do
        before { sign_in_user(user_question) }

        it_behaves_like 'forbidden response'

        it 'isnt deletes the vote from the database' do
          expect { request }.to_not change(question.votes, :count)
        end

        it 'isnt decreases the question value' do
          question.reload
          expect(question.total_votes).to eq 1
        end
      end

      context 'for not own question' do
        before { sign_in_user(another_user) }

        it 'deletes the vote from database' do
          expect { request }.to change(question.votes, :count).by(-1)
        end

        it 'decreases the question value' do
          request
          question.reload
          expect(question.total_votes).to eq 0
        end
      end
    end
  end
end