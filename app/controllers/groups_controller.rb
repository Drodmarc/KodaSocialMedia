class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      flash[:notice] = "Successfully Created"
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
    authorize @group, :edit?, policy_class: GroupPolicy
  end

  def update
    authorize @group, :update?, policy_class: GroupPolicy
    if @group.update(group_params)
      flash[:notice] = "Successfully Updated"
      redirect_to groups_path
    else
      render :edit
    end
  end

  def destroy
    authorize @group, :destroy?, policy_class: GroupPolicy
    if @group.destroy
      flash[:notice] = "Successfully Deleted"
    else
      flash[:alert] = "Can't delete this post!"
    end
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :image, :description, :privacy)
  end

  def set_group
    @group = Group.find(params[:id])
  end
end