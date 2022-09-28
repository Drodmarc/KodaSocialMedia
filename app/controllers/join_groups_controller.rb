class JoinGroupsController < ApplicationController
  before_action :set_join_group, except: :create

  def create
    group_exist = current_user.join_groups.find_by(group_id: params[:group_id])
    if update_join_group = current_user.join_groups.where.not(state: [:pending, :approved]).find_by(group_id: params[:group_id])
      update_join_group.request!
      flash[:notice] = "You successfully added"
      redirect_to groups_path
    elsif group_exist.blank?
      join_group = current_user.join_groups.new(group_id: params[:group_id], role: :member)
      if join_group.save!
        flash[:notice] = "You successfully added"
        redirect_to groups_path
      else
        flash[:alert] = join_group.errors.full_messages.join(', ')
      end
    else
      flash[:alert] = "You can't join this group again!"
      redirect_to groups_path
    end
  end

  def approve
    if @join_group.approve!
      flash[:notice] = "Approve Successfully"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to group_path(params[:group_id])
  end

  def remove
    if @join_group.remove!
      flash[:notice] = "Remove Successfully"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to groups_path
  end

  def ignore
    if @join_group.ignore!
      flash[:notice] = "Ignore Successfully"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to groups_path
  end

  def leave
    if @join_group.leave!
      flash[:notice] = "Leave Successfully"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to groups_path
  end

  def cancel
    if @join_group.cancel!
      flash[:notice] = "Cancel Successfully"
    else
      flash[:alert] = @join_group.errors.full_messages.join(', ')
    end
    redirect_to groups_path(records: :requests)
  end

  private

  def set_join_group
    @join_group = JoinGroup.find(params[:join_group_id])
  end
end