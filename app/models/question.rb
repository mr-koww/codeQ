class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscribers, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user, presence: true
  validates :title, length: { in: 10..35 }
  validates :body, length:  { in: 10..250 }

  after_create :subscribe_author

  def subscribed?(user)
    subscribers.where(user_id: user).present?
  end

  private
  def subscribe_author
    subscribers.create(user: user)
  end
end