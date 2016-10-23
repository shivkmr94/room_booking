class Admin::UsersController < ApplicationController
  before_filter :authenticate_admin

  before_filter :find_user, :except => [:index]
  layout "admin/admin"
  
  def index
    @users = User.all.order("created_at desc")
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path
    end
  end


  protected

  def find_user
    @user = User.find(params[:id]) rescue nil
  end

  def user_params
    params.require(:user).permit!
  end
end
