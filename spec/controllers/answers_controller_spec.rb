require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
let(:user) { create :user }
let(:question) { create :question, user: user }
let(:answer)   { create :answer, question: question }

  describe 'GET #new' do
    sign_in_user

    before { get :new, question_id: question}

    it { expect(assigns(:answer)).to be_a_new(Answer) }
    it { expect(response).to render_template :new }
  end


	describe 'POST #create' do
    sign_in_user

		context 'with valid attributes' do
			it 'saves answer to db' do
		  	expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
      end

      it 'should have a user' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(assigns(:answer).user).to eq subject.current_user
      end

			it 'redirect to show view' do
        post :create, answer: attributes_for(:answer), question_id: question
				expect(response).to redirect_to question_path(question)
  		end
		end

		context 'with invalid attributes' do
			it 'doesn`t save the answer' do
				expect { post :create, answer: { body: nil }, question_id: question}.to_not change(Answer, :count)
      end

      it 'redirect to show view' do
        post :create, answer: { body: nil }, question_id: question
        expect(response).to redirect_to question_path(question)
      end
    end

	end


  describe 'PATCH #update' do
    sign_in_user

    context 'with valid params' do

      it 'assigns the requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer), question_id: question
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, id: answer, answer: { body: 'New Answer Body' }, question_id: question
        answer.reload
        expect(answer.body).to eq 'New Answer Body'
      end

    end

    context 'with invalid params' do
      before { patch :update, id: answer, answer: { body: nil }, question_id: question }

      it 'not change answer attributes' do
        answer.reload
        expect(answer.body).to eq answer.body
      end
   end
  end

  #дописать
  describe 'DELETE #destroy' #проверить удаление ответа
  describe 'GET #show' #проверить вывод нескольких ответов по конкретному вопросу
  describe 'GET #edit' #проверить форму редактирования

end