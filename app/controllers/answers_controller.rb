class AnswersController < ApplicationController
  before_action :set_question
  before_action :load_answer, only: [:edit, :update]

  def new
    @answer = Answer.new
  end


  def show
    @answer = @question.answers.find(params[:id])
    #redirect_to question_answers_path(@question)
  end


  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end


  def update
    if @answer.update(answer_params)
      redirect_to @question
    else
      render :edit
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
