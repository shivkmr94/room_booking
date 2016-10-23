class Api::V1::ApiApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
#  protect_from_forgery with: :exception
  
  helper :all
  before_action :load_filter

  def load_filter
    if params[:key].present?
      authenticate_user_from_token!
    else
      authenticate_user!
    end
  end
  
  
 
  private  
  # For this example, we are simply using token authentication
  # via parameters. However, anyone could use Rails's token
  # authentication features to get the token from a header.
  def authenticate_user_from_token!
    key = params[:key].presence
    user = key && User.find_by_key(key)
    if user.nil?
      render :status=>401, :json=>{:status=>"Failure", :status_code => 401, :message=>"Invalid Key."}
      return
    end
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:authentication_token]) && user.authentication_token.present?
      sign_in user, store: true
    else
      render :status=>401, :json=>{:status=>"Failure", :status_code => 401, :message=>"Invalid Authentication token."}
      return
    end
  end
  
end
