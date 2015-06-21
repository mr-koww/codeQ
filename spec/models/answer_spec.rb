require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { should validate_presence_of :question }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(250) }

  it { should belong_to :question }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user, best: false) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user, best: true) }

  describe '.best' do
    before { answer.best! }

    it 'only one answer has mark the best' do
      expect(question.answers.where(best: true).count).to eq 1
    end

    it 'best anwer must be show first in list' do
      question.answers.reload
      expect(question.answers.first).to eq answer
    end
  end

  describe '.vote/.unvote' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user:user) }
    let(:answer) { create(:answer, user: user, question: question ) }

    it 'votes as like' do
      answer.vote(user, 1)

      expect(user.votes.find_by(votable: answer).value).to eq 1
      expect(Vote.where(user_id: user, votable: answer).count).to eq 1
    end

    it 'votes as dislike' do
      answer.vote(user, -1)

      expect(user.votes.find_by(votable: answer).value).to eq -1
      expect(Vote.where(user_id: user, votable: answer).count).to eq 1
    end

    it 'unvotes' do
      answer.vote(user, 1)
      answer.unvote(user)

      expect(Vote.where(user_id: user, votable: answer).count).to eq 0
    end
  end

  describe '.notify_subscribers' do
    let(:users) { create_list(:user, 2) }
    let(:subscriber1) { create(:subscriber, user: users[0], question: question) }
    let(:subscriber2) { create(:subscriber, user: users[1], question: question) }
    let(:subscribers) { [ subscriber1, subscriber2 ] }

    it 'should send email for all subscribers' do
      subscribers.each { |subscriber| expect(NotifyMailer).to receive(:new_answer).twice.with(subscriber).and_call_original }
      answer
    end
  end
end