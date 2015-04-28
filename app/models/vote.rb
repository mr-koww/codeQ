class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, :user, :votable_id, :votable_type, presence: true
  validates :value, inclusion: [1, -1]
  validates :votable_type, inclusion: ['Question', 'Answer']


  #def voted_by?(user)
  #  votes.where(user: user).any?
  #end

  def total_votes
    votes.sum(:value)
  end

  #def vote_by(user)
  #  vote = votes.find_by(user: user)
  #  vote.value unless vote.nil?
  #end
end