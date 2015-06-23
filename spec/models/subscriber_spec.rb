require 'rails_helper'

describe Subscriber, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

end