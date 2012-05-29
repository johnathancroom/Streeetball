class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in
  
  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  def logged_in
    !!self.current_user
  end
  
  private
  
  def require_credentials
    if current_user.nil? || (params[:id].present? && params[:id] != current_user.id.to_s) || (params[:username].present? && params[:username] != current_user.username)
      redirect_to signin_url, :alert => "You're not allowed there!"
    end
  end
  
  def require_login
    if !logged_in
      redirect_to signin_url, :alert => "Please log in"
    end
  end
  
  def require_admin
    render :text => "Admin only, yo!", :status => 403
  end
  
  # Error handling
  if ENV['RAILS_ENV'] == 'production' # Production only
    rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction, :with => :render_404
    rescue_from RuntimeError, :with => :render_500
  end
  
  def render_404
    render 'pages/error', :status => :404
  end
  
  def render_500
    render 'pages/error', :status => 500
  end
end
