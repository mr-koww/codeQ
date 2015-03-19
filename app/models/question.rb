class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { in: 10..35 }
  validates :body, length:  { in: 20..250 }

end
