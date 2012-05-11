class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in
  
  AWS::S3::S3Object.set_current_bucket_to 'streeetball'
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def logged_in
    !!self.current_user
  end
  
  private
  
  def require_credentials
    if current_user.nil? || params[:id] != current_user.id.to_s
      redirect_to login_url, :alert => "You're not allowed there!"
    end
  end
  
  def require_login
    if current_user.nil?
      redirect_to login_url, :alert => "Please log in"
    end
  end
  
  def require_admin
    render :text => "Admin only, yo!", :status => 403
  end
end
