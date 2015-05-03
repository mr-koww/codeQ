class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, :user, :commentable_id, :commentable_type, presence: true
  validates :commentable_type, inclusion: ['Question', 'Answer']

end