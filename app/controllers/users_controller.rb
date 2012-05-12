class UsersController < ApplicationController
  before_filter :require_credentials, :only => [:edit, :update]
  before_filter :require_admin, :only => [:index, :destroy]
  
  before_filter :get_user, :only => [:show, :edit, :update]
  
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
    @user = User.where('lower(username) = ?', params[:username].downcase).first
    
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
      
        format.html { redirect_to confirmation_path }
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
    @params = params[:user]

    # Profile image
    if params[:user][:image_url] && @user.valid?
      # Delete previous profile image
      AWS::S3::S3Object.delete @user.image_url if @user.image_url
      
      # Amazonify profile image upload
      filename = @user.username + "/profile_image" + File.extname(params[:user][:image_url].original_filename)
      AWS::S3::S3Object.store filename, params[:user][:image_url].read, :access => :public_read
      @params[:image_url] = filename
    end

    respond_to do |format|
      if @user.update_attributes(@params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
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
      redirect_to @user, :status => 301
    end
  end
end
