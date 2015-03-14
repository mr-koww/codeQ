require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it '1. Population an array of all Question' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it '2. Renders index view' do
      expect(response).to render_template :index
    end
  end


  describe 'GET #show' do
    before { get :show, id: question }

    it '1. Assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it '2. Renders show view' do
      expect(response).to render_template :show
    end
  end


  describe 'GET #new' do
    before { get :new }

    it '1. Assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it '2. Renders new view' do
      expect(response).to render_template :new
    end
  end


  describe 'GET #edit' do
    before { get :edit, id: question }

    it '1. Assigns requested question to @questions' do
      expect(assigns(:question)).to eq question
    end

    it '2. Renders edit view' do
      expect(response).to render_template :edit
    end
  end


  describe 'POST #create' do
    context 'with valid attributes' do
      it '1. Saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it '2. Redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

    end

    context 'with invalid attributes' do
      it '1. Does not save question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it '2. Re-render new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end


  describe 'PATCH #update' do
    context 'with valid attributes' do
      it '1. Assigns requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it '2. Changes question attributes' do
        patch :update, id: question, question: { title: "new title", body: "new body" }
        question.reload
        expect(question.title).to eq "new title"
        expect(question.body).to eq "new body"
      end

      it '3. Redirect to the updates question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end

    end

    context 'with invalid attributes' do
      before { patch :update, id: question, question: { title: "new title", body: nil } }
      it '1. Does not change question attributes' do
        question.reload
        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end

      it '2. Re-render edit template' do
        expect(response).to render_template :edit
      end
    end
  end

end
