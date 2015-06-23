require 'rails_helper'

describe NotifyQuestionSubscribersJob, type: :job do
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:subscribers) { [ create(:subscriber, question: question, user: create(:user)),
                        create(:subscriber, question: question, user: create(:user)) ] }

  it 'sends email with digest for all subscribers' do
    question.subscribers.each do |subscriber|
      expect(NotifyMailer).to receive(:new_answer).twice.with(subscriber).and_call_original
    end
    NotifyQuestionSubscribersJob.perform_now(question)
  end
end
