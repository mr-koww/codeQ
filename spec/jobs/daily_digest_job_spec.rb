require 'rails_helper'

describe DailyDigestJob, type: :job do
  let!(:users) { create_list :user, 2 }

  it 'sends email with digest for all users' do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user).and_call_original
    end
    DailyDigestJob.perform_now
  end
end