class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else # guest
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
    can :create, [ Question, Answer, Comment ]
    can :update, [ Question, Answer, Comment ], user: user
    can :destroy, [ Question, Answer, Comment ], user: user

    can :best, Answer
    cannot :best, Answer, user_id: user.id

    can [ :like, :dislike ], [ Question, Answer ] do |resource|
      (resource.user_id != user.id) && !resource.voted_by?(user)
    end

    can [ :unvote ], [ Question, Answer ] do |resource|
      (resource.user_id != user.id) && resource.voted_by?(user)
    end
  end
end
