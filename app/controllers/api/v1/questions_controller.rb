class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end

  def create
    respond_with @question = Question.create(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body).merge(user_id: current_resource_owner.id)
  end
end