class Question < ActiveRecord::Base
  has_many :answer, dependent: :destroy

  validates :title, :body, presence: true

end
