require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

let(:question) { create :question }
let(:answer)   { create :answer, question: question }



  describe 'GET #new' do
    before { get :new, question_id: question}

    it { expect(assigns(:answer)).to be_a_new(Answer) }
    it { expect(response).to render_template :new }

  end

	describe "POST #create" do
		context "with valid attributes" do

			it "saves answer to db" do
		  	expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
      end

			#it "redirect to index template" do
			#	get :index, question_id: question
			#	expect(response).to render_template :index
  		#end
		end

		context "with invalid attributes" do
			it "doesn`t save the answer" do
				expect { post :create, answer: { body: nil }, question_id: question}.to_not change(Answer, :count)
			end

			#it "redirect to index template" do
			#	get :index, question_id: question
			#	expect(response).to render_template :index
			#end
		end
	end

  describe 'PATCH #update' do
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

     #it 'render edit view' do
     #  expect(response).to render_template :edit
     #end
   end
  end

end