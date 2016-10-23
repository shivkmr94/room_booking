class Api::V1::TokensController  < Api::V1::ApiApplicationController
  skip_before_action :load_filter
  skip_before_action :authenticate_user!

  respond_to :json
  
  def create
    render :status=>406, :json=>{:status=>"Failure",:message=>"The request must be json"} and return if request.format != :json
    render :status=>400,:json=>{:status=>"Failure",:message=>"The request must contain the email and password."} and return if params[:email].nil? or params[:password].nil?
    @user=User.find_by_email(params[:email].downcase)
    render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid email"} and return if @user.nil?
    @user.ensure_authentication_token
    if not @user.valid_password?(params[:password])
      render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid password."}
    else
      render :status=>200, :json=>{:status=>"Success",:authentication_token=>@user.authentication_token,:key=>@user.key}
    end    
  end
 
  def destroy
    key = params[:key].presence
    user = key && User.find_by_key(key)
 		if user.nil?
 			render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid Key."}
      return
 		end
    if user and Devise.secure_compare(user.authentication_token, params[:authentication_token]) && user.authentication_token.present?
      user.update_column(:authentication_token, nil)
      render :status=>200, :json=>{:status=>"Success",:message=>"Authentication token set to nil"}
    else
    	render :status=>401, :json=>{:status=>"Failure",:message=>"Invalid Authentication token."}
      return
    end
  end
end

