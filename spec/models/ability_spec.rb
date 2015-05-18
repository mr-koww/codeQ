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
    let(:user) { create(:user, admin:true) }

    it { should be_able_to :manage, :all}
  end

  describe 'for auth user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:myQuestion) { create(:question, user: user) }
    let(:otherQuestion) { create(:question, user: other) }

    let(:myAnswer) { create(:answer, question: myQuestion, user: user) }
    let(:otherAnswer) { create(:answer, question: myQuestion, user: other) }

    let(:myComment) { create(:comment, commentable: myQuestion, user: user) }
    let(:otherComment) { create(:comment, commentable: myQuestion, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    # create
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    # update
    it { should be_able_to :update, myQuestion, user: user }
    it { should_not be_able_to :update, otherQuestion, user: user }

    it { should be_able_to :update, myAnswer, user: user }
    it { should_not be_able_to :update, otherAnswer, user: user }

    it { should be_able_to :update, myComment, user: user }
    it { should_not be_able_to :update, otherComment, user: user }

    # destroy
    it { should be_able_to :destroy, myQuestion, user: user }
    it { should_not be_able_to :destroy, otherQuestion, user: user }

    it { should be_able_to :destroy, myAnswer, user: user }
    it { should_not be_able_to :destroy, otherAnswer, user: user }

    it { should be_able_to :destroy, myComment, user: user }
    it { should_not be_able_to :destroy, otherComment, user: user }

    # like/dislike (Question)
    it { should_not be_able_to :like, myQuestion, user: user }
    it { should be_able_to :like, otherQuestion, user: user }

    it { should_not be_able_to :dislike, myQuestion, user: user }
    it { should be_able_to :dislike, otherQuestion, user: user }

    it { should_not be_able_to :unvote, myQuestion, user: user }

    # like/dislike (Answer)
    it { should_not be_able_to :like, myAnswer, user: user }
    it { should be_able_to :like, otherAnswer, user: user }

    it { should_not be_able_to :dislike, myAnswer, user: user }
    it { should be_able_to :dislike, otherAnswer, user: user }

    it { should_not be_able_to :unvote, myAnswer, user: user }

    # best (Answer)
    it { should_not be_able_to :best, myAnswer, user: user }
    it { should be_able_to :best, otherAnswer, user: user }
  end
end