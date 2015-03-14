require 'rails_helper'

RSpec.describe Question, type: :model do
  it "1. not nil title" do
    should validate_presence_of :title
  end

  it "2. not nil body" do
    should validate_presence_of :body
  end

  it "3. title have length in [5..35] range" do
    should validate_length_of(:title).is_at_least(10).is_at_most(35)
  end

  it "4. body have length in [10..255] range" do
    should validate_length_of(:body).is_at_least(20).is_at_most(250)
  end

  it "5. delete question with all dependent answers" do
  should have_many(:answer).dependent(:destroy)
  end

end
