class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [ :create ]
  before_action :load_comment, only: [ :update, :destroy ]
  # before_action :comment_author?, only: [ :update, :destroy ]
  after_action  :publish_comment, only: [ :create ]

  respond_to :js

  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(comment_params))
  end

  def update
    @comment.update(comment_params)
    respond_with @comment
  end

  def destroy
    respond_with(@comment.destroy)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end

  def load_commentable
    model = params[:commentable].classify.constantize
    param = (params[:commentable].singularize + '_id').to_sym
    @commentable = model.find(params[param])
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def publish_comment
    return unless @comment.valid?
    commentable_type = @comment.commentable_type.underscore.pluralize
    commentable_id = @comment.commentable_id
    channel = "/#{ commentable_type }/#{ commentable_id }/comments"
    PrivatePub.publish_to channel, comment: @comment.to_json
  end
end