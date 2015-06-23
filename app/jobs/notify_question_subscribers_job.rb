class NotifyQuestionSubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    question.subscribers.each do |subscriber|
      NotifyMailer.new_answer(subscriber).deliver_later
    end
  end
end
