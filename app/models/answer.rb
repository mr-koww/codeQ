class Answer < ActiveRecord::Base
  has_many :attachments, as: :attachable, dependent: :destroy

  belongs_to :question
  belongs_to :user

  accepts_nested_attributes_for :attachments, reject_if: proc { |attrib| attrib['file'].nil? }, allow_destroy: true

  validates :body, :user, presence: true
  validates :body, length:  { in: 5..250 }

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  def best!
    question.answers.update_all(best: false)
    self.update(best: true)
  end
end