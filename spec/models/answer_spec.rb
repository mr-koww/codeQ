require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(250) }
  it { should belong_to :question }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user, best: false) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user, best: true) }

  describe 'Best answer' do
    before { answer.best! }

    it 'answer was mark the best' do
      expect(answer.best).to be_truthy
    end

    it 'others answers wasn\'t mark the best' do
      answers.each do |answer|
        answer.reload
        expect(answer.best).to be_falsey
      end
    end

    it 'best anwer must be show first in list' do
      question.answers.reload
      expect(question.answers.first).to eq answer
    end
  end
end