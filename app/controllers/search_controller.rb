class SearchController < ApplicationController
  skip_authorization_check

  def index
    respond_with finder
  end

  private
  def finder
    @results = {
        questions: Question.search(params[:q]),
        answers: Answer.search(params[:q]),
        comments: Comment.search(params[:q])
    }
  end
end