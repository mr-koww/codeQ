class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :user, presence: true
  validates :body, length:  { in: 5..250 }
end
