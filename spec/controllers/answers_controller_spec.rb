require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

# User who wrote Question (but not wrote Answer)
let(:user1) { create :user }

# User who wrote Answer
let(:user2) { create :user }

let!(:question) { create :question, user: user1 }
let!(:answer)   { create :answer, question: question, user: user2, best: false }
let(:file) { create(:attachment, attachable: answer) }

	describe 'POST #create' do
    before do
      sign_in_user(user2)
    end

		context 'with valid attributes' do
			it 'saves answer to db' do
		  	expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.
            to change(question.answers, :count).by(1)
      end

      it 'saves the attachment in the database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, attachment: file, format: :js }.
            to change(answer.attachments, :count).by(1)
      end

      it 'should have a user' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(assigns(:answer).user).to eq subject.current_user
      end

			it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
				expect(response).to render_template :create
  		end
		end

		context 'with invalid attributes' do
			it 'doesn`t save the answer' do
				expect { post :create, answer: { body: nil }, question_id: question, format: :js}.
            to_not change(Answer, :count)
      end

      it 'render error view' do
        #post :create, answer: { body: nil }, question_id: question, format: :js
        #expect(response).to render_template :create
      end
    end
	end


  describe 'PATCH #update' do
    before do
      sign_in_user(user2)
    end

    context 'with valid params' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, id: answer, answer: { body: 'New Answer Body' }, question_id: question, format: :js
        answer.reload
        expect(answer.body).to eq 'New Answer Body'
      end

      it 'assigns the question' do
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'render update template' do
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid params' do
      it 'not change answer attributes' do
        patch :update, id: answer, answer: { body: nil }, question_id: question, format: :js
        answer.reload
        expect(answer.body).to eq answer.body
      end
   end
  end


  describe 'DELETE #destroy' do
    context 'user try delete his answer' do
      before do
        sign_in_user(user2)
        answer
      end

      it 'delete the answer from the database' do
        expect { delete :destroy, id: answer.id, question_id: question, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, id: answer.id, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user try delete not his question' do
      before do
        sign_in_user(user1)
        question
        answer
      end

      it 'delete the question from the database' do
        expect { delete :destroy, id: answer.id, question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'redirect to questions' do
        delete :destroy, id: answer.id, question_id: question, format: :js
        expect(response).to redirect_to question_path(question)
      end
    end
  end


  describe 'PATCH #best' do
    context 'user, owner question, try mark to the best answer' do
      before do
        sign_in_user(user1)
        patch :best, id: answer, question_id: question, format: :js
      end

      it 'mark answer to the best' do
        answer.reload
        expect(answer.best).to eq true
      end

      it 'renders best template' do
        expect(response).to render_template :best
      end
    end

    context 'user, not owner question, try to mark the best answer' do
      it 'not mark answer to the best' do
        sign_in_user(user2)
        patch :best, id: answer, question_id: question, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end

  #дописать
  describe 'GET #edit' #проверить форму редактирования
end