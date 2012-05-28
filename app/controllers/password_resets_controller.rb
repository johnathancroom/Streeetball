class PasswordResetsController < ApplicationController
  def create
    user = User.where('lower(email) = lower(?)', params[:email]).first
    user.send_password_reset if user
    redirect_to signin_path, :notice => "Email sent to #{params[:email]} with password reset instructions."
  end
  
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end
