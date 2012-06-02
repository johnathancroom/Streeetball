class SessionsController < ApplicationController
  def create
    if @user = User.authenticate(params[:user], params[:password])
      if @user.email_confirmed
        cookies.permanent[:auth_token] = @user.auth_token
        redirect_to params[:referrer] || root_url, :notice => 'Signed in!' # Redirect to referrer (set in login form), default to root_url if referrer doesn't exist
      else
        render 'email_confirmations/show'
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