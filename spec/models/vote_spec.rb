require 'rails_helper'

RSpec.describe Vote, type: :model do

  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_array(%w(1 -1)) }
  it { should validate_presence_of :user }
  it { should validate_presence_of :votable_type }
  it { should validate_inclusion_of(:votable_type).in_array(['Question', 'Answer']) }
  it { should validate_presence_of :votable_id }
  it { should belong_to :user }

end