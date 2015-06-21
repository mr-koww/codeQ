require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all}
  end

  describe 'for auth user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }

    let(:answer) { create(:answer, question: question, user: user) }
    let(:other_answer) { create(:answer, question: question, user: other) }

    let(:comment) { create(:comment, commentable: question, user: user) }
    let(:other_comment) { create(:comment, commentable: question, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    # create
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    # update
    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, other_question, user: user }

    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, other_answer, user: user }

    it { should be_able_to :update, comment, user: user }
    it { should_not be_able_to :update, other_comment, user: user }

    # destroy
    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, other_question, user: user }

    it { should be_able_to :destroy, answer, user: user }
    it { should_not be_able_to :destroy, other_answer, user: user }

    it { should be_able_to :destroy, comment, user: user }
    it { should_not be_able_to :destroy, other_comment, user: user }

    # like/dislike/unvote (Question)
    it { should_not be_able_to :like, question, user: user }
    it { should be_able_to :like, other_question, user: user }

    it { should_not be_able_to :dislike, question, user: user }
    it { should be_able_to :dislike, other_question, user: user }

    it { should_not be_able_to :unvote, question, user: user }

    # like/dislike/unvote (Answer)
    it { should_not be_able_to :like, answer, user: user }
    it { should be_able_to :like, other_answer, user: user }

    it { should_not be_able_to :dislike, answer, user: user }
    it { should be_able_to :dislike, other_answer, user: user }

    it { should_not be_able_to :unvote, answer, user: user }

    # best (Answer)
    it { should_not be_able_to :best, answer, user: user }
    it { should be_able_to :best, other_answer, user: user }


    describe 'Subscribe' do
      context ':create' do
        it { should be_able_to :create, Subscriber }
        end

      context ':destroy' do
        context 'when subscribed' do
          let(:subscriber) { create(:subscriber, question: question, user: user) }

          it { should be_able_to :destroy, subscriber }
        end

        context 'when not subscribed (other subscribe)' do
          let(:subscriber) { create(:subscriber, question: question, user: other) }

          it { should_not be_able_to :destroy, subscriber }
        end
      end
    end
  end
end