class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :load_answer, except: [ :create ]

  include Voted


  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    unless @answer.save
      render json: set_json_fail_response(t('answer.notice.create.fail'), @answer.errors.full_messages[0]),
          status: :unprocessable_entity
    end
  end


  def update
    unless @answer.update(answer_params)
      render json: set_json_fail_response(t('answer.notice.update.fail'), @answer.errors.full_messages[0]),
          status: :unprocessable_entity
    end
  end


  def destroy
    if current_user.id == @answer.user_id
      @answer.destroy
    else
      redirect_to question_path(@question)
    end
  end


  def best
    if current_user.id == @question.user_id
      @answer.best!
    end
  end


  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, attachments_attributes: [:id, :file, :_destroy])
  end

  def set_json_fail_response(notice, notice_error)
    { notice: notice, notice_error: notice_error }
  end
end