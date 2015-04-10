class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :user, presence: true
  validates :body, length:  { in: 5..250 }

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  def best!
    question.answers.update_all(best: false)
    self.update(best: true)
  end
end
