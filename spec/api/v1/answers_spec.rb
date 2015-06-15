require_relative '../../rails_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question, user: user) }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get api_v1_question_answers_path(question), format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get api_v1_question_answers_path(question), format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 7, question: question, user: user) }
      before { get api_v1_question_answers_path(question), format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

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

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get api_v1_answer_path(answer), format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get api_v1_answer_path(answer), format: :json, access_token: '12345'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:comment)    { create(:comment, commentable: answer, user: user) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before { get api_v1_answer_path(answer), format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it 'contains attachment url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json). at_path("answer/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do
    let(:question)   { create(:question, user: user) }
    let(:owner_user) { User.find(access_token.resource_owner_id) }
    def request( attributes = {} )
      post api_v1_question_answers_path(question), { format: :json }.merge(attributes)
    end

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        request(answer: attributes_for(:answer))
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        request(answer: attributes_for(:answer), access_token: '12345')
        expect(response.status).to eq 401
      end
    end

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