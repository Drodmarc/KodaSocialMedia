class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:index, :new, :create]

  def index
    join_groups = current_user.join_groups.where.not(state: [:removed, :ignored, :leaved, :cancelled])
    group_ids = join_groups.pluck(:group_id)
    @group_lists = Group.where.not(id: group_ids) if params[:records].blank? || params[:records] == 'group_lists'
    @requests = join_groups.pending.includes(:group) if params[:records] == 'requests'
    @joined_groups = current_user.join_groups.approved.where.not(is_owner: true).includes(:group) if params[:records] == 'joined_groups'
    @manage_groups = current_user.join_groups.approved.where.not(role: :member).includes(:group) if params[:records] == 'manage_groups'
  end

  def new
    @group = Group.new
  end

  def show
    @approvals = JoinGroup.where.not(user: current_user).where(group: @group).pending.includes(:user) if params[:records] == 'approvals'
    @members = JoinGroup.where(group: @group).approved.includes(:user) if params[:records] == 'members' || params[:records] == 'assign_role'
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save!
      join_group = JoinGroup.new(state: :approved, role: :admin, is_owner: true, user: current_user, group: @group)
      join_group.save!
      flash[:notice] = "Successfully Created"
      redirect_to groups_path(records: :manage_groups)
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
      @group.join_groups.destroy_all
      flash[:notice] = "Successfully Deleted"
    else
      flash[:alert] = "Can't delete this post!"
    end
    redirect_to groups_path(records: :manage_groups)
  end

  private

  def group_params
    params.require(:group).permit(:name, :image, :description, :privacy)
  end

  def set_group
    @group = Group.find(params[:id])
  end
end