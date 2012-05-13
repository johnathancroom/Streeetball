class PostsController < ApplicationController
  before_filter :require_login, :only => [:new, :create, :destroy]
  before_filter :require_admin, :only => [:edit, :update]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    
    @comments = @post.comments
    
    # Add description to comments if it exists
    @description_comment = Comment.new({ :user_id => @post.user.id, :blurb => @post.description })
    @description_comment.created_at = @post.created_at
    @comments = [@description_comment] + @comments if @post.description

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
    
    # if image was uploaded and post is valid
    if params[:post][:image] && @post.valid?
      # Amazonify upload from posts#new form
      filename = @post.user.username + "/" + File.basename(params[:post][:image].original_filename, ".*") + "_" + Time.now.to_i.to_s + File.extname(params[:post][:image].original_filename)
      AWS::S3::S3Object.store filename, params[:post][:image].read, :access => :public_read
      @post.image_url = "#{filename}"
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
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
end
