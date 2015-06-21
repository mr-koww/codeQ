class Answer < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, :user, :question, presence: true
  validates :body, length:  { in: 5..250 }, allow_blank: true

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  after_create :notify_subscribers

  def best!
    question.answers.update_all(best: false)
    self.update(best: true)
  end

  private
  def notify_subscribers
    question.subscribers.find_each do |subscriber|
       NotifyMailer.new_answer(subscriber).deliver_later
    end
  end
end