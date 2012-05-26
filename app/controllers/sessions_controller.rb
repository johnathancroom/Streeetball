class SessionsController < ApplicationController
  def new
  end
  
  def create
    if user = User.authenticate(params[:user], params[:password])
      if user.email_confirmed
        cookies.permanent[:auth_token] = user.auth_token
        redirect_to root_url, :notice => 'Signed in!'
      else
        redirect_to verify_path
      end
    else
      flash.now.alert = 'Invalid login credentials'
      render 'new'
    end
  end
  
  def destroy
    cookies.delete(:auth_token)
    redirect_to :back, :notice => 'Signed out!'
  end
end