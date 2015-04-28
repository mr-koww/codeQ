require 'rails_helper'

RSpec.describe Vote, type: :model do

  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_array(%w(1 -1)) }
  it { should validate_presence_of :user }
  it { should validate_presence_of :votable_type }
  it { should validate_inclusion_of(:votable_type).in_array(['Question', 'Answer']) }
  it { should validate_presence_of :votable_id }
  it { should belong_to :user }


  describe 'Vote for question' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'votes as like' do
      question.vote(user, 1)

      expect(user.votes.find_by(votable: question).value).to eq 1
      expect(Vote.where(user_id: user, votable_id: question.id, votable_type: question.class.name).count).to eq 1
    end

    it 'votes as dislike' do
      question.vote(user, -1)

      expect(user.votes.find_by(votable: question).value).to eq -1
      expect(Vote.where(user_id: user, votable_id: question.id, votable_type: question.class.name).count).to eq 1
    end

    it 'unvotes' do
      question.vote(user, 1)
      question.unvote(user)

      expect(Vote.where(user_id: user, votable_id: question.id, votable_type: question.class.name).count).to eq 0
    end
  end

  describe 'Vote for answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user:user) }
    let(:answer) { create(:answer, user: user, question: question ) }

    it 'votes as like' do
      answer.vote(user, 1)

      expect(user.votes.find_by(votable: answer).value).to eq 1
      expect(Vote.where(user_id: user, votable_id: answer.id, votable_type: answer.class.name).count).to eq 1
    end

    it 'votes as dislike' do
      answer.vote(user, -1)

      expect(user.votes.find_by(votable: answer).value).to eq -1
      expect(Vote.where(user_id: user, votable_id: answer.id, votable_type: answer.class.name).count).to eq 1
    end

    it 'unvotes' do
      answer.vote(user, 1)
      answer.unvote(user)

      expect(Vote.where(user_id: user, votable_id: answer.id, votable_type: answer.class.name).count).to eq 0
    end
  end
end