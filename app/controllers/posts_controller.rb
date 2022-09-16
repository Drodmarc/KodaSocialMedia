class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user).order(id: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      flash[:notice] = "Successfully Created"
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = "Successfully Updated"
      redirect_to posts_path
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "Successfully Deleted"
    else
      flash[:alert] = "Can't delete this post!"
    end
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:image, :content, :genre)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end