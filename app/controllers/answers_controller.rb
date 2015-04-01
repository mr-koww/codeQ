class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_question
  before_action :load_answer, only: [ :edit, :update, :destroy ]

  def new
    @answer = Answer.new
  end


  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    redirect_to @answer.question
  end


  def update
    if @answer.update(answer_params)
      redirect_to @question
    else
      render :edit
    end
  end


  def destroy
    if current_user.id == @answer.user_id
      if @answer.destroy
        redirect_to question_path(@question), notice: 'Your answer was successfully destroyed.'
      end
    end
  end


  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
