class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [ :show, :edit, :update, :destroy ]

  def index
    @questions = Question.all
  end


  def show
    @answers = @question.answers
    @answer = Answer.new
  end


  def new
    @question = Question.new
  end


  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      flash[:notice] = 'Please, check question data'
      render :new
    end
  end


  def update
    @question.update(question_params)
  end


  def destroy
    if current_user.id == @question.user_id
      @question.destroy!
      redirect_to questions_path, notice: 'Your question was successfully destroyed.'
    else
      redirect_to @question
    end
  end


  private
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

end