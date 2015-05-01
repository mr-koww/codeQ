require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

# User who wrote Question (but not wrote Answer)
let(:user_question) { create :user }

# User who wrote Answer
let(:user_answer) { create :user }

let!(:question) { create :question, user: user_question }
let!(:answer)   { create :answer, question: question, user: user_answer, best: false }
let(:file) { create(:attachment, attachable: answer) }

	describe 'POST #create' do
    before do
      sign_in_user(user_answer)
    end

		context 'with valid attributes' do
			it 'saves answer to db' do
		  	expect { post :create, answer: attributes_for(:answer), question_id: question, format: :json }.
            to change(question.answers, :count).by(1)
      end

      it 'saves the attachment in the database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, attachment: file, format: :json }.
            to change(answer.attachments, :count).by(1)
      end

      it 'should have a user' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :json
        expect(assigns(:answer).user).to eq subject.current_user
      end

			it 'render 200 response status' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :json
				expect(response).to have_http_status(200)
  		end
		end

		context 'with invalid attributes' do
			it 'doesn`t save the answer' do
				expect { post :create, answer: { body: nil }, question_id: question, format: :json}.
            to_not change(Answer, :count)
      end

      it 'render 422 response status' do
        post :create, answer: { body: nil }, question_id: question, format: :json
        expect(response).to have_http_status(422)
      end
    end
	end


  describe 'PATCH #update' do
    before do
      sign_in_user(user_answer)
    end

    context 'with valid params' do
      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question, format: :json
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, id: answer, answer: { body: 'New Answer Body' }, question_id: question, format: :json
        answer.reload
        expect(answer.body).to eq 'New Answer Body'
      end

      it 'render 200 response status' do
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question, format: :json
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      before { patch :update, id: answer, answer: { body: nil }, question_id: question, format: :json }

      it 'not change answer attributes' do
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 'render 422 response status' do
        expect(response).to have_http_status(422)
      end
   end
  end


  describe 'DELETE #destroy' do
    context 'when user try delete own answer' do
      before do
        sign_in_user(user_answer)
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

    context 'when user try delete not own question' do
      before do
        sign_in_user(user_question)
        question
        answer
      end

      it 'delete the question from the database' do
        expect { delete :destroy, id: answer.id, question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'renders Forbidden status' do
        delete :destroy, id: answer.id, question_id: question, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end


  describe 'PATCH #best' do
    context 'when user, owner question, try mark to the best answer' do
      before do
        sign_in_user(user_question)
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

    context 'when user, not owner question, try to mark the best answer' do
      it 'not mark answer to the best' do
        sign_in_user(user_answer)
        patch :best, id: answer, question_id: question, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end


  describe 'PATCH #like' do
    context 'when auth user tries vote as like for not own answer' do
      before do
        sign_in_user(user_question)
      end

      it 'saves the new vote in the database' do
        expect { patch :like, id: answer, question_id: question, format: :json }.to change(answer.votes, :count).by(1)
      end

      it 'increases the answer value' do
        patch :like, id: answer, question_id: question, format: :json
        answer.reload
        expect(answer.total_votes).to eq 1
      end

      it 'renders OK status' do
        patch :like, id: answer, question_id: question, format: :json
        expect(response).to have_http_status(200)
      end
    end

    context 'when auth user tries vote as like for own answer' do
      before { sign_in_user(user_answer) }

      it 'isn\t saves the new vote in the database' do
        expect { patch :like, id: answer, question_id: question, format: :json }.to_not change(answer.votes, :count)
      end

      it 'isn\'t increases the answer value' do
        patch :dislike, id: answer, question_id: question, format: :json

        answer.reload
        expect(answer.total_votes).to eq 0
      end

      it 'renders Forbidden status' do
        patch :dislike, id: answer, question_id: question, format: :json

        expect(response).to have_http_status(403)
      end
    end

    context 'when not auth user tries vote as like for anything answer' do
      before { patch :like, id: answer, question_id: question, format: :json }

      it 'renders Unauthorized status' do
        expect(response).to have_http_status(401)
      end
    end
  end


  describe 'PATCH #dislike' do
    context 'when auth user tries vote as dislike for not own answer' do
      before do
        sign_in_user(user_question)
      end

      it 'saves the new vote in the database' do
        expect { patch :dislike, id: answer, question_id: question, format: :json }.to change(answer.votes, :count).by(1)
      end

      it 'increases the answer value' do
        patch :dislike, id: answer, question_id: question, format: :json
        answer.reload
        expect(answer.total_votes).to eq -1
      end

      it 'renders OK status' do
        patch :dislike, id: answer, question_id: question, format: :json
        expect(response).to have_http_status(200)
      end
    end

    context 'when auth user tries vote as dislike for own answer' do
      before do
        sign_in_user(user_answer)
      end

      it 'isn\t saves the new vote in the database' do
        expect { patch :dislike, id: answer, question_id: question, format: :json }.to_not change(answer.votes, :count)
      end

      it 'isn\'t increases the answer value' do
        patch :dislike, id: answer, question_id: question, format: :json

        answer.reload
        expect(answer.total_votes).to eq 0
      end

      it 'renders Forbidden status' do
        patch :dislike, id: answer, question_id: question, format: :json

        expect(response).to have_http_status(403)
      end
    end

    context 'when not auth user tries vote as dislike for anything answer' do
      before { patch :dislike, id: answer, question_id: question, format: :json }

      it 'renders Unauthorized status' do
        expect(response).to have_http_status(401)
      end
    end
  end


  describe 'PATCH #unvote' do
    let!(:vote) { create(:vote, votable: answer, user: user_question, value: 1) }

    context 'when auth user tries unvote for not own answer' do
      before do
        sign_in_user(user_question)
      end

      it 'saves the new vote in the database' do
        expect { patch :unvote, id: answer, question_id: question, format: :json }.to change(answer.votes, :count).by(-1)
      end

      it 'increases the answer value' do
        patch :unvote, id: answer, question_id: question, format: :json

        answer.reload
        expect(answer.total_votes).to eq 0
      end

      it 'renders OK status' do
        patch :unvote, id: answer, question_id: question, format: :json
        expect(response).to have_http_status(200)
      end
    end

    context 'when auth user tries vote as dislike for own answer' do
      before { sign_in_user(user_answer) }

      it 'isn\'t saves the new vote in the database' do
        expect { patch :unvote, id: answer, question_id: question, format: :json }.to_not change(answer.votes, :count)
      end

      it 'isn\'t increases the answer value' do
        patch :unvote, id: answer, question_id: question, format: :json

        answer.reload
        expect(answer.total_votes).to eq 1
      end

      it 'renders Forbidden status' do
        patch :unvote, id: answer, question_id: question, format: :json

        expect(response).to have_http_status(403)
      end
    end

    context 'when not auth user tries vote as dislike for anything answer' do
      before { patch :unvote, id: answer, question_id: question, format: :json }

      it 'renders Unauthorized status' do
        expect(response).to have_http_status(401)
      end
    end
  end


end