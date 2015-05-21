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
    let(:my_question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }

    let(:my_answer) { create(:answer, question: my_question, user: user) }
    let(:other_answer) { create(:answer, question: my_question, user: other) }

    let(:my_comment) { create(:comment, commentable: my_question, user: user) }
    let(:other_comment) { create(:comment, commentable: my_question, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    # create
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    # update
    it { should be_able_to :update, my_question, user: user }
    it { should_not be_able_to :update, other_question, user: user }

    it { should be_able_to :update, my_answer, user: user }
    it { should_not be_able_to :update, other_answer, user: user }

    it { should be_able_to :update, my_comment, user: user }
    it { should_not be_able_to :update, other_comment, user: user }

    # destroy
    it { should be_able_to :destroy, my_question, user: user }
    it { should_not be_able_to :destroy, other_question, user: user }

    it { should be_able_to :destroy, my_answer, user: user }
    it { should_not be_able_to :destroy, other_answer, user: user }

    it { should be_able_to :destroy, my_comment, user: user }
    it { should_not be_able_to :destroy, other_comment, user: user }

    # like/dislike (Question)
    it { should_not be_able_to :like, my_question, user: user }
    it { should be_able_to :like, other_question, user: user }

    it { should_not be_able_to :dislike, my_question, user: user }
    it { should be_able_to :dislike, other_question, user: user }

    it { should_not be_able_to :unvote, my_question, user: user }

    # like/dislike (Answer)
    it { should_not be_able_to :like, my_answer, user: user }
    it { should be_able_to :like, other_answer, user: user }

    it { should_not be_able_to :dislike, my_answer, user: user }
    it { should be_able_to :dislike, other_answer, user: user }

    it { should_not be_able_to :unvote, my_answer, user: user }

    # best (Answer)
    it { should_not be_able_to :best, my_answer, user: user }
    it { should be_able_to :best, other_answer, user: user }
  end
end