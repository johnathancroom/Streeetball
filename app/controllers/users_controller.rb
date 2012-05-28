class UsersController < ApplicationController
  before_filter :get_user, :only => [:show, :edit, :update]
  
  before_filter :require_credentials, :only => [:edit, :update]
  before_filter :require_admin, :only => [:index, :destroy]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      @user.send_email_confirmation # Send the confirmation
      
      render 'email_confirmations/show' # Show the confirmation page
    else
      render :action => 'new'
    end
  end

  # PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      if params[:user][:local_avatar].present?
        render :action => 'crop', :notice => 'Crop to your desire like a playa'
      else
        redirect_to @user, :notice => 'You updated your profile, yo!'
      end
    else
      render :action => 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  # DRY Functions
  def get_user
    @user = User.where('lower(username) = lower(?)', params[:username]).first
    
    # User doesn't exist
    if @user.nil?
      render_404
      return
    end
    
    if params[:username] != @user.username
      if params[:action] == "edit"
        redirect_to edit_user_path(@user.username), :status => 301
      else
        redirect_to @user, :status => 301
      end
    end
  end
end
