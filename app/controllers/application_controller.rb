class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
  private
  
  def require_login
    if params[:id] != current_user.id.to_s
      redirect_to login_url, :alert => "Please login"
    end
  end
  
  def require_admin
    render :text => "Admin only, yo!"
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
