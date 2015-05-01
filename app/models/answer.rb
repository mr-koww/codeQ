class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :question
  belongs_to :user

  validates :body, :user, :question, presence: true
  validates :body, length:  { in: 5..250 }, allow_blank: true

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  def best!
    question.answers.update_all(best: false)
    self.update(best: true)
  end
end