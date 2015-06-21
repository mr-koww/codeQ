class NotifyMailer < ApplicationMailer
  def new_answer(subscriber)
    @greeting = "Hi"
    email = subscriber.user.email
    mail to: email if email
  end
end
