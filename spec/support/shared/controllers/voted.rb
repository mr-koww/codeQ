shared_examples_for 'voted' do

  describe 'PATCH /like' do
    def request(attributes = {})
      patch :like, { id: resource, format: :js }.merge(attributes)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'for own resource' do
        before { sign_in_user(resource_user) }

        it_behaves_like 'forbidden response'

        it 'isnt increases the resource value' do
          request
          resource.reload
          expect(resource.total_votes).to eq 0
        end

        it 'isnt saves the new vote in the database' do
          expect { request }.to_not change(Vote, :count)
        end
      end

      context 'for not own resource' do
        before { sign_in_user(create(:user)) }

        it 'increases the resource value' do
          request
          resource.reload
          expect(resource.total_votes).to eq 1
        end

        it 'saves the new vote in the database' do
          expect { request }.to change(resource.votes, :count).by(1)
        end
      end
    end
  end

  describe 'PATCH /dislike' do
    def request(attributes = {})
      patch :dislike, { id: resource, format: :js }.merge(attributes)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      context 'for own resource' do
        before { sign_in_user(resource_user) }

        it_behaves_like 'forbidden response'

        it 'isnt saves the new vote in the database' do
          expect { request }.to_not change(resource.votes, :count)
        end

        it 'isnt increases the resource value' do
          request
          resource.reload
          expect(resource.total_votes).to eq 0
        end
      end

      context 'for not own resource' do
        before { sign_in_user(create(:user)) }

        it 'saves the new vote in the database' do
          expect { request }.to change(resource.votes, :count).by(1)
        end

        it 'increases the resource value' do
          request
          resource.reload
          expect(resource.total_votes).to eq -1
        end
      end
    end
  end

  describe 'PATCH /unvote' do
    def request(attributes = {})
      patch :unvote, { id: resource, format: :js }.merge(attributes)
    end

    it_behaves_like 'unauthorized response for not auth user'

    context 'auth user' do
      let(:user_who_vote) { create(:user)}
      let!(:vote) { create(:vote, votable: resource, user: user_who_vote, value: 1) }

      context 'for not own vote' do
        before { sign_in_user(create(:user)) }

        it_behaves_like 'forbidden response'

        it 'isnt deletes the vote from the database' do
          expect { request }.to_not change(resource.votes, :count)
        end

        it 'isnt decreases the resource value' do
          resource.reload
          expect(resource.total_votes).to eq 1
        end
      end

      context 'for own vote' do
        before { sign_in_user(user_who_vote) }

        it 'deletes the vote from database' do
          expect { request }.to change(resource.votes, :count).by(-1)
        end

        it 'decreases the resource value' do
          request
          resource.reload
          expect(resource.total_votes).to eq 0
        end
      end
    end
  end
end