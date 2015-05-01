module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: [ :like, :dislike, :unvote ]
    before_action :user_can_vote?, only: [ :like, :dislike, :unvote ]
  end


  def like
    @resource.vote(current_user, 1)
    render_success_json_response('vote', 'Like OK')
  end


  def dislike
    @resource.vote(current_user, -1)
    render_success_json_response('vote', 'Dislike OK')
  end


  def unvote
    @resource.unvote(current_user)
    render_success_json_response('unvote', 'Unvote OK')
  end


  private
  def set_resource
    @resource = instance_variable_get("@#{controller_name.singularize}")
  end

  def user_can_vote?
    if @resource.user_id == current_user.id
      render text: 'You don\'t have permission to view this page!', status: :forbidden
    end
  end

  def render_success_json_response(type, notice)
    render json: Hash[:class, @resource.class.name.underscore, :id, @resource.id, :type, type, :value, @resource.total_votes, :notice, notice]
  end
end