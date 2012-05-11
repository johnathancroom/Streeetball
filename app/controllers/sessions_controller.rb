class SessionsController < ApplicationController
  def new
  end
  
  def create
    if user = User.authenticate(params[:user], params[:password])
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      redirect_to signin_url, :alert => "Invalid login credentials"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to :back, :notice => "Logged out!"
  end
end
