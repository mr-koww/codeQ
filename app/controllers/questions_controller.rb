class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, except: [ :index, :new, :create ]
  after_action  :publish_question, only: [ :create ]
  include Voted

  respond_to :html, :js, :json

  authorize_resource

  def index
    respond_with(@questions = Question.paginate(page: params[:page], per_page: 10))
  end

  def show
    @answer = @question.answers.build
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

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
      .merge(user_id: current_user.id)
  end

  def publish_question
    return unless @question.valid?
    PrivatePub.publish_to "/questions", question: @question.to_json
  end
end