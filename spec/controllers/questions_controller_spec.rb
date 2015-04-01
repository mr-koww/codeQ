require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

let(:user) { create :user }
let(:question) { create :question, user: user }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }
    before { get :index }

    it 'Population an array of all Question' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'Renders index view' do
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    before { get :show, id: question }

    it 'Assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'Renders show view' do
      expect(response).to render_template :show
    end

    it 'Assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end


  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'Assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'Renders new view' do
      expect(response).to render_template :new
    end
  end


  describe 'GET #edit' do
    sign_in_user

    before { get :edit, id: question }

    it 'Assigns requested question to @questions' do
      expect(assigns(:question)).to eq question
    end

    it 'Renders edit view' do
      expect(response).to render_template :edit
    end
  end


  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'Saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'Redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'should have a user' do
        post :create, question: attributes_for(:question)
        expect(assigns(:question).user).to eq subject.current_user
      end

    end

    context 'with invalid attributes' do
      it 'Does not save question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 'Re-render new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end


  describe 'PATCH #update' do
    sign_in_user

    context 'with valid attributes' do
      it 'Assigns requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end
      it 'Changes question attributes' do
        patch :update, id: question, question: { title: 'new default title', body: 'new default body' }
        question.reload
        expect(question.title).to eq 'new default title'
        expect(question.body).to eq 'new default body'
      end
      it 'Redirect to the updates question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end

    end

    context 'with invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil } }

      it 'Does not change question attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
      it 'Re-render edit template' do
        expect(response).to render_template :edit
      end
    end
  end


  #дописать
  describe 'DELETE #destroy'

end
