class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [ Question, Answer, Comment, Subscriber ]
    can :update, [ Question, Answer, Comment ], user: user
    can :destroy, [ Question, Answer, Comment ], user: user

    can :destroy, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end

    can :destroy, Subscriber do |subscriber|
      user.subscribers.where(question_id: subscriber.question).present?
    end

    can :best, Answer do |answer|
      answer.question.user_id == user.id && answer.user_id != user.id
    end

    can [ :like, :dislike ], [ Question, Answer ] do |votable|
      (votable.user_id != user.id) && !votable.voted?(user)
    end

    can [ :unvote ], [ Question, Answer ] do |votable|
      votable.voted?(user)
    end
  end
end