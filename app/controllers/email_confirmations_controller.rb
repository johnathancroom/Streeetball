class EmailConfirmationsController < ApplicationController
  def create
    @user = User.where('lower(email) = lower(?)', params[:email]).first
    @user.send_email_confirmation if @user # Send the confirmation
    
    render :show
  end
  
  def edit
    @user = User.find_by_email_confirmation_token(params[:id])
    @user.update_attribute(:email_confirmed, true)
    cookies.permanent[:auth_token] = @user.auth_token # Log in
    
    redirect_to @user, :notice => 'Your email has been confirmed and you have been signed in.'
  end
end