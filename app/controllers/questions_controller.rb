class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, except: [ :index, :new, :create ]
  before_action :question_author?, only: [ :update, :destroy ]
  before_action :build_answer, only: [ :show ]
  after_action  :publish_question, only: [ :create ]
  include Voted

  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private
  def load_question
    @question = Question.find(params[:id])
  end

  def question_author?
    render nothing: true, status: :forbidden unless current_user.id == @question.user_id
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
      .merge(user_id: current_user.id)
  end

  def publish_question
    PrivatePub.publish_to "/questions", question: @question.to_json
  end
end