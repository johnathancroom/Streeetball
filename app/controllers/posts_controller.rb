class PostsController < ApplicationController
  before_filter :require_login, :only => [:new, :create, :destroy, :update]
  before_filter :require_admin, :only => [:edit]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where("image_file_name != ''").reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    
    # Post wasn't completely uploaded (probably exited during crop)
    if @post.image_file_name.nil?
      render_404
      return 
    end
    
    @comments = @post.comments
    
    # Add description to comments if it exists
    @description_comment = Comment.new({ :user_id => @post.user.id, :blurb => @post.description })
    @description_comment.created_at = @post.created_at
    @comments = [@description_comment] + @comments if @post.description != ''

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    
    # Set user_id
    @post.user_id = current_user.id

    if @post.save
      # Add description to comments for preview if it exists
      @description_comment = Comment.new({ :user_id => @post.user.id, :blurb => @post.description })
      @description_comment.created_at = @post.created_at
      @comments = [@description_comment] if @post.description != ''
    
      render :action => 'crop', :notice => 'Crop to your desire like a playa'
    else
      render :new
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Image was successfully posted.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  
  # POST /posts/1/like
  def like
    @post = Post.find(params[:id])
    
    # Check if not logged in
    if !logged_in
      flash[:alert] = 'You must sign in if you want to like this'
      render :json => { :reload => true }
      return
    end
    
    # Check if this is your post
    if @post.user.id == current_user.id
      flash[:alert] = 'You can\'t like your own post'
      render :json => { :reload => true }
      return
    end
    
    # Check if like already exists
    if @like = @post.likes.find_by_user_id(current_user.id)
      @like.destroy
      status = false
    else
      @post.likes.create({ :user_id => current_user.id, :post_id => @post.id })
      status = true
      
      HookMailer.like_email(current_user, @post) # Email post owner about the like they just recieved!
    end
    
    render :json => { :like => status, :count => @post.likes.count }
  end
end
