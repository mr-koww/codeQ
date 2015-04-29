require 'rails_helper'

describe Question, type: :model do

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(35) }
  it { should validate_length_of(:body).is_at_least(10).is_at_most(250) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  describe 'Votable' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'votes as like' do
      question.vote(user, 1)

      expect(user.votes.find_by(votable: question).value).to eq 1
      expect(Vote.where(user_id: user, votable: question).count).to eq 1
    end

    it 'votes as dislike' do
      question.vote(user, -1)

      expect(user.votes.find_by(votable: question).value).to eq -1
      expect(Vote.where(user_id: user, votable: question).count).to eq 1
    end

    it 'unvotes' do
      question.vote(user, 1)
      question.unvote(user)

      expect(Vote.where(user_id: user, votable: question).count).to eq 0
    end
  end

end