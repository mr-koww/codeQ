require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
let(:user) { create :user }
let(:question) { create :question, user: user }
let(:answer)   { create :answer, question: question }

  describe 'GET #new' do
    sign_in_user

    before { get :new, question_id: question }

    it { expect(assigns(:answer)).to be_a_new(Answer) }
    it { expect(response).to render_template :new }
  end


	describe 'POST #create' do
    sign_in_user

		context 'with valid attributes' do
			it 'saves answer to db' do
		  	expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.
            to change(question.answers, :count).by(1)
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

      it 'redirect to show view' do
        post :create, answer: { body: nil }, question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
	end


  describe 'PATCH #update' do
    sign_in_user

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

  #дописать
  describe 'DELETE #destroy' #проверить удаление ответа
  describe 'GET #show' #проверить вывод нескольких ответов по конкретному вопросу
  describe 'GET #edit' #проверить форму редактирования

end