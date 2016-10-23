class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  
  def authenticate_admin
    unless (user_signed_in? and current_user.admin?)
      redirect_to root_path
    end
   end

  def after_sign_in_path_for(resource_or_scope)
    if current_user.present? and current_user.admin?
      admin_users_path
    else
      root_path
    end
  end
end
