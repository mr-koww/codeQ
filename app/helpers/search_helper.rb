module SearchHelper
  def search_path_helper(scope)
    search_path(scope: scope, q: params[:q], utf8: "✓")
  end

  def render_questions
    render 'search/questions', questions: @results[:questions]
  end

  def render_answers
    render 'search/answers', answers: @results[:answers]
  end

  def render_comments
    render 'search/comments', comments: @results[:comments]
  end
end
