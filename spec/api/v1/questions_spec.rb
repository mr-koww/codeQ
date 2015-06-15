require_relative '../../rails_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token) }

  describe 'GET /index' do
    def request(attributes = {})
      get api_v1_questions_path, { format: :json }.merge(attributes)
    end

    it_behaves_like 'API should be authorization'

    context 'authorized' do
      let!(:questions) { create_list(:question, 3, user: user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: user) }
      before { request(access_token: access_token.token) }

      it_behaves_like 'API success response'

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end
  
  describe 'GET /show' do
    let!(:question)    { create(:question, user: user) }
    let!(:comment)    { create(:comment, commentable: question, user: user) }
    let!(:attachment) { create(:attachment, attachable: question) }
    def request(attributes = {})
      get api_v1_question_path(question), { format: :json }.merge(attributes)
    end

    it_behaves_like 'API should be authorization'

    context 'authorized' do
      before { request(access_token: access_token.token) }

      it_behaves_like 'API success response'

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachment' do
        it 'included in object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        it 'contains attachment url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json). at_path("question/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do
    let(:owner_user) { User.find(access_token.resource_owner_id) }
    def request(attributes = {})
      post api_v1_questions_path, { format: :json }.merge(attributes)
    end

    it_behaves_like 'API should be authorization'

    context 'authorized' do
      let(:create_question) { request(question: attributes_for(:question), access_token: access_token.token) }

      it 'returns 201 status code' do
        create_question
        expect(response.status).to eq 201
      end

      it 'saves the new object to database' do
        expect { create_question }.to change(Question, :count).by(1)
      end

      it 'assign new object to current user' do
        create_question
        expect(assigns(:question).user).to eq(owner_user)
      end
    end
  end
end