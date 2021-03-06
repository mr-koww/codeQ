class SubscribersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [ :create ]
  before_action :load_subscriber, only: [ :destroy ]

  authorize_resource

  def create
    respond_with @question.subscribers.find_or_create_by(user: current_user), location: @question
  end

  def destroy
    @question = @subscriber.question
    respond_with(@subscriber.destroy, location: @question)
  end

  private
  def load_subscriber
    @subscriber = Subscriber.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end