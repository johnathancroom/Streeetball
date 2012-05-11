class SessionsController < ApplicationController
  def new
  end
  
  def create
    if user = User.authenticate(params[:user], params[:password])
      if user.email_confirmed
        session[:user_id] = user.id
        redirect_to root_url, :notice => 'Signed in!'
      else
        redirect_to confirmation_path
      end
    else
      flash.now.alert = 'Invalid login credentials'
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to :back, :notice => 'Signed out!'
  end
end