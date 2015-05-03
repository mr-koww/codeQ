require 'rails_helper'

describe CommentsController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, user: author, question: question) }

  describe 'POST #create' do
    context 'when auth user tries comment QUESTION' do
      context 'with valid attributes' do
        let(:create_question_comment) do
          post(:create, commentable: 'questions', question_id: question, comment: attributes_for(:comment), format: :json)
        end

        before { sign_in_user(user) }

        it 'saves a new comment in the database' do
          expect { create_question_comment }.to change(Comment, :count).by(1)
        end

        it 'associates the new comment with the question' do
          expect { create_question_comment }.to change(question.comments, :count).by(1)
        end

        it 'has OK response status' do
          create_question_comment
          expect(response.status).to eq 200
        end
      end

      context 'with invalid attributes' do
        let(:create_question_comment) do
          post(:create, commentable: 'questions', question_id: question, comment: { body: nil }, format: :json)
        end

        before { sign_in_user(user) }

        it 'does not save a new comment in the database' do
          expect { create_question_comment }.to_not change(Comment, :count)
        end

        it 'has Unprocessable Entity response status' do
          create_question_comment
          expect(response.status).to eq 422
        end
      end

      context 'Non authenticated user' do
        it 'does not save a comment in the database' do
          expect { post(:create, commentable: 'questions', question_id: question,
              comment: { body: nil }, format: :json) }.to_not change(Comment, :count)
        end
      end
    end

    context 'when auth user tries comment ANSWER' do
      context 'with valid attributes' do
        let(:create_answer_comment) do
          post(:create, commentable: 'answers', answer_id: answer, comment: attributes_for(:comment), format: :json)
        end

        before { sign_in_user(user) }

        it 'saves a new comment in the database' do
          expect { create_answer_comment }.to change(Comment, :count).by(1)
        end

        it 'associates the new comment with the answer' do
          expect { create_answer_comment }.to change(answer.comments, :count).by(1)
        end

        it 'has OK response status' do
          create_answer_comment
          expect(response.status).to eq 200
        end
      end

      context 'with invalid attributes' do
        let(:create_answer_comment) do
          post(:create, commentable: 'answers', answer_id: answer, comment: { body: nil }, format: :json)
        end

        before { sign_in_user(user) }

        it 'does not save a new comment in the database' do
          expect { create_answer_comment }.to_not change(Comment, :count)
        end

        it 'has Unprocessable Entity response status' do
          create_answer_comment
          expect(response.status).to eq 422
        end
      end

      context 'Non authenticated user' do
        it 'does not save a comment in the database' do
          expect { post(:create, commentable: 'answers', answer_id: answer,
              comment: { body: nil }, format: :json) }.to_not change(Comment, :count)
        end
      end
    end
  end
end