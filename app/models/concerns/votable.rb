module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(voter, value)
    vote = votes.find_or_initialize_by(user: voter)
    vote.value = value
    vote.save!
  end

  def unvote(voter)
    votes.where(user: voter).delete_all
  end

  def voted?(voter)
    votes.where(user: voter).any?
  end

  def total_votes
    votes.sum(:value)
  end
end