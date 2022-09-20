class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]

  def index
    @comments = @post.comments.includes(:user)
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.post = @post
    @comment.user = current_user
    if @comment.save
      redirect_to post_comments_path
      flash[:notice] = "Successfully Created"
    else
      render :new
    end
  end

  def edit
    authorize @comment, :edit?, policy_class: CommentPolicy
  end

  def update
    authorize @comment, :update?, policy_class: CommentPolicy
    if @comment.update(comment_params)
      flash[:notice] = "Successfully Updated"
      redirect_to post_comments_path
    else
      render :edit
    end
  end

  def destroy
    authorize @comment, :destroy?, policy_class: CommentPolicy
    if @comment.destroy
      flash[:notice] = "Successfully Deleted"
      redirect_to post_comments_path
    end
  end

  private

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def set_post
    @post = Post.find params[:post_id]
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end