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
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        ConfirmationMailer.welcome_email(@user).deliver
      
        format.html { redirect_to verify_path }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if @user.update_attributes(params[:user])
      if params[:user][:local_avatar].blank?
        flash[:notice] = 'You updated your profile, yo!'
        redirect_to @user
      else
        flash[:notice] = 'Crop to your desire like a playa'
        render :action => 'crop'
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
  
  # GET /verify/{base64 id}
  def verify
    @user = User.find(Base64.decode64(params[:id]).to_i)
    @user.update_attribute(:email_confirmed, true)
    session[:user_id] = @user.id
    
    redirect_to @user, :notice => "Email confirmed."
  end
  
  # DRY Functions
  def get_user
    @user = User.where('lower(username) = ?', params[:username].downcase).first
    
    if params[:username] != @user.username
      if params[:action] == "edit"
        redirect_to edit_user_path(@user.username), :status => 301
      else
        redirect_to @user, :status => 301
      end
    end
  end
end
