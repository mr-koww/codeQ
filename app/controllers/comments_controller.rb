class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [ :create ]
  before_action :load_comment, only: [ :update, :destroy ]
  before_action :comment_author?, only: [ :update, :destroy ]

  respond_to :json

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      publish(@comment.to_json)
      render_json(:ok, 'create', t('comment.notice.create.success'), @comment)
    else
      render_json(:unprocessable_entity, 'error', t('comment.notice.update.fail'), @comment.errors.full_messages)
    end
  end


  def update
    if @comment.update(comment_params)
      publish(@comment.to_json)
      render_json(:ok, 'create', t('comment.notice.update.success'), @comment)
    else
      render_json(:unprocessable_entity, 'error', t('comment.notice.update.fail'), @comment.errors.full_messages)
    end
  end


  def destroy
    if @comment.destroy
      render_json(:ok, 'destroy', t('comment.notice.destroy.success'))
    else
      render_json(:unprocessable_entity, 'error', t('comment.notice.destoy.fail'), @comment.errors.full_messages)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    model = params[:commentable].classify.constantize
    param = (params[:commentable].singularize + '_id').to_sym
    @commentable = model.find(params[param])
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def comment_author?
    render nothing: true, status: :forbidden unless current_user.id == @comment.user_id
  end

  def publish(data)
    commentable_type = @comment.commentable_type.underscore.pluralize
    commentable_id = @comment.commentable_id
    channel = "/#{ commentable_type }/#{ commentable_id }/comments"
    PrivatePub.publish_to channel, data: data
  end
end