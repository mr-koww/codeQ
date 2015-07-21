require 'rails_helper'

describe CommentsController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }

  let(:commentable) { create(:question, user: author) }
  let(:commentable_type) { 'questions' }
  let(:commentable_param) {  }

  describe 'POST /create' do
    def request(_attr = {})
      post(:create, commentable: commentable_type, question_id: commentable, comment: attributes_for(:comment), format: :js)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      let(:channel) { "/questions/#{commentable.id}/comments" }

      before { sign_in_user(author) }

      context 'with valid attributes' do
        it 'saves new comment in database' do
          expect { request }.to change(Comment, :count).by(1)
        end

        it 'associates the new comment with the question' do
          expect { request }.to change(commentable.comments, :count).by(1)
        end

        it 'should have the user' do
          request
          expect(assigns(:comment).user).to eq subject.current_user
        end

        it_behaves_like 'publishable'
      end

      context 'with invalid attributes' do
        def bad_request
          post :create, commentable: commentable_type, question_id: commentable, comment: { body: nil }, format: :js
        end
        before { sign_in_user(author) }

        it 'does not save a new comment in the database' do
          expect { bad_request }.to_not change(Comment, :count)
        end

        it_behaves_like 'not publishable'
      end
    end
  end

  describe 'PATCH /update' do
    let!(:comment) { create(:comment, commentable: commentable, user: author) }
    def request(_attr = {})
      patch(:update, commentable: commentable_type, id: comment, comment: { body: 'New comment' }, format: :js)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'own comment' do
        before { sign_in_user(author) }

        context 'with valid attributes' do
          it 'changes comment attributes' do
            request
            comment.reload
            expect(comment.body).to eq 'New comment'
          end
        end

        context 'with invalid attributes' do
          def bad_request(_attr = {})
            patch(:update, commentable: commentable_type, id: comment, comment: { body: nil }, format: :js)
          end

          it 'doesnt changes the comment in  database' do
            old_comment_body = comment.body
            bad_request
            comment.reload
            expect(comment.body).to eq old_comment_body
          end
        end
      end

      context 'not own comment' do
        before { sign_in_user(user) }

        it_behaves_like 'forbidden response'

        it 'doesnt changes the comment in  database' do
          old_comment_body = comment.body
          request
          comment.reload
          expect(comment.body).to eq old_comment_body
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:comment) { create(:comment, commentable: commentable, user: author) }
    def request(_attr = {})
      patch(:destroy, commentable: commentable_type, id: comment, format: :js)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'own comment' do
        before { sign_in_user(author) }

        it 'deletes comment from the database' do
          expect { request }.to change(Comment, :count).by(-1)
        end
      end

      context 'not own comment' do
        before { sign_in_user(user) }

        it_behaves_like 'forbidden response'

        it 'doesnt deletes comment from the database' do
          expect { request }.to_not change(Comment, :count)
        end
      end
    end
  end
end