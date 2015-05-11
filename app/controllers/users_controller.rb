class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user
  before_action :correct_user?
  before_action :check_email, only: [ :change_email ]
  respond_to :html, :json

  def show
  end


  def change_email
    @user.email = user_params[:email]
    if @user.save
      flash[:success] = t('devise.confirmations.send_instructions')
    else
      flash[:alert] = t('users.email.notice.change.fail')
    end
    redirect_to user_path(@user)
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def correct_user?
    render nothing: true, status: :forbidden unless current_user.id == @user.id
  end

  def check_email
    if user_params[:email].empty?
      flash[:alert] = t('users.email.notice.change.empty')
    elsif @user.email == user_params[:email]
      flash[:notice] = t('users.email.notice.change.same')
    elsif
      existing_user = User.where(email: user_params[:email]).first
      if existing_user
        flash[:alert] = t('users.email.notice.change.busy')
      end
    end
    redirect_to user_path(@user) unless flash.empty?
  end

  def user_params
    params.require(:user).permit(:email)
  end

end