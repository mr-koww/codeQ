class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user, presence: true
  validates :title, length: { in: 10..35 }
  validates :body, length:  { in: 10..250 }

  accepts_nested_attributes_for :attachments
end