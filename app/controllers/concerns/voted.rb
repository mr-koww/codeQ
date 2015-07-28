module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: [ :like, :dislike, :unvote ]
  end

  def like
    respond_with @resource.vote(current_user, 1)
    # render_success_json_response('vote', 'Like OK')
  end

  def dislike
    respond_with @resource.vote(current_user, -1)
    # render_success_json_response('vote', 'Dislike OK')
  end

  def unvote
    respond_with @resource.unvote(current_user)
    # render_success_json_response('unvote', 'Unvote OK')
  end

  private
  def set_resource
    @resource = instance_variable_get("@#{ controller_name.singularize }")
  end
end
