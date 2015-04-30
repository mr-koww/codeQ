class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: [ :create ]
  before_action :answer_author?, only: [ :update, :destroy ]
  before_action :load_question, only: [ :create ]
  before_action :question_author?, only: [ :best ]
  include Voted

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    unless @answer.save
      json_error_response(:unprocessable_entity, t('answer.notice.create.fail'), @answer.errors.full_messages[0])
    end
  end

  def update
    unless @answer.update(answer_params)
      json_error_response(:unprocessable_entity, t('answer.notice.create.fail'), @answer.errors.full_messages[0])
    end
  end

  def destroy
    @answer.destroy
  end

  def best
    @answer.best!
  end

  private

  def load_answer
    json_error_response(:not_found, 'Answer Not Found') unless @answer = Answer.find(params[:id])
  end

  def answer_author?
    json_error_response(:forbidden, 'Only author can update/delete answer') unless current_user == @answer.user
  end

  def load_question
    json_error_response(:not_found, 'Question Not Found') unless @question = Question.find(params[:question_id])
  end

  def question_author?
    json_error_response(:forbidden, 'Only author question can check the best answer') unless current_user == @answer.question.user
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, attachments_attributes: [:id, :file, :_destroy])
  end

  def json_error_response(status, message, error = "")
    render json: { message: message, errors: error }, status: status
  end
end