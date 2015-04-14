class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user, presence: true
  validates :title, length: { in: 10..35 }
  validates :body, length:  { in: 10..250 }

end