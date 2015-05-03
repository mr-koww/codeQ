require 'rails_helper'

describe Comment, type: :model do

  it { should belong_to :commentable }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }
  it { should validate_inclusion_of(:commentable_type).in_array(['Question', 'Answer']) }
end