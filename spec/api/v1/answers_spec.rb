require_relative '../../rails_helper'

describe 'Answers API' do
  let(:root) { 'answer' }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question, user: user) }

  describe 'GET /index' do
    def request(attributes = {})
      get api_v1_question_answers_path(question), { format: :json }.merge(attributes)
    end

    it_behaves_like 'API should be authorization'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 7, question: question, user: user) }
      before { request(access_token: access_token.token) }

      it_behaves_like 'API success response'

      it 'returns list of answers' do
        expect(response.body).to have_json_size(7).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          answer = answers.first
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:answer) { create(:answer, question: question, user: user) }
    def request(attributes = {})
      get api_v1_answer_path(answer), { format: :json }.merge(attributes)
    end

    it_behaves_like 'API should be authorization'

    context 'authorized' do
      let!(:comment)    { create(:comment, commentable: answer, user: user) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      before { request(access_token: access_token.token) }

      it_behaves_like 'API success response'

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it_behaves_like 'API commentable'
      it_behaves_like 'API attachable'
    end
  end

  describe 'POST /create' do
    let(:question)   { create(:question, user: user) }
    let(:owner_user) { User.find(access_token.resource_owner_id) }
    def request(attributes = {})
      post api_v1_question_answers_path(question), { format: :json }.merge(attributes)
    end

    it_behaves_like 'API should be authorization'

    context 'authorized' do
      context 'with valid attributes' do
        let(:create_answer) { request(answer: attributes_for(:answer), access_token: access_token.token) }

        it 'returns 201 status code' do
          create_answer
          expect(response.status).to eq 201
        end

        it 'saves the new object to database' do
          expect { create_answer }.to change(question.answers, :count).by(1)
        end

        it 'assign new object to current user' do
          create_answer
          expect(assigns(:answer).user).to eq(owner_user)
        end
      end

      context 'with invalid attributes' do
        let(:create_answer) { request(answer: { question: question, body: nil }, access_token: access_token.token) }

        it 'returns 422 status code' do
          create_answer
          expect(response.status).to eq 422
        end

        it 'not saves the new object to database' do
          expect { create_answer }.to_not change(question.answers, :count)
        end
      end
    end
  end
end