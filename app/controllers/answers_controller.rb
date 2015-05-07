class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: [ :create ]
  before_action :answer_author?, only: [ :update, :destroy ]
  before_action :load_question, only: [ :create ]
  before_action :question_author?, only: [ :best ]
  after_action  :publish_answer, only: [ :create ]
  include Voted

  respond_to :html, :js, :json

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def best
    respond_with(@answer.best!)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_author?
    render nothing: true, status: :forbidden unless current_user.id == @answer.user_id
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def question_author?
    @question = @answer.question
    render nothing: true, status: :forbidden unless current_user.id == @question.user_id
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, attachments_attributes: [:id, :file, :_destroy])
      .merge(user_id: current_user.id)
  end

  def publish_answer
    PrivatePub.publish_to "/questions/#{ @question.id }/answers", answer: @answer.to_json
  end
end