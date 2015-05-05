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
      render_json(:unprocessable_entity, 'error', t('answer.notice.create.fail'), @answer.errors.full_messages[0])
    end

    PrivatePub.publish_to "/questions/#{ @question.id }/answers", answer: @answer.to_json
    #render nothing: true
  end

  def update
    unless @answer.update(answer_params)
      render_json(:unprocessable_entity, 'error', t('answer.notice.update.fail'), @answer.errors.full_messages[0])
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
    render nothing: true, status: :not_found unless @answer = Answer.find(params[:id])
  end

  def answer_author?
    render nothing: true, status: :forbidden unless current_user.id == @answer.user_id
  end

  def load_question
    render nothing: true, status: :not_found unless @question = Question.find(params[:question_id])
  end

  def question_author?
    @question = @answer.question
    render nothing: true, status: :forbidden unless current_user == @question.user
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, attachments_attributes: [:id, :file, :_destroy])
  end
end