class CommentsController < ApplicationController
  before_filter :require_login, :only => [:new, :create]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # POST /comments
  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    @comment.post_id = params[:post_id]

    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(@comment.post_id), notice: 'Comment posted.' }
      else
        format.html { redirect_to post_path(@comment.post_id), alert: 'Something went wrong when commenting' }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end
end
