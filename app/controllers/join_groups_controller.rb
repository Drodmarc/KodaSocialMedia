class JoinGroupsController < ApplicationController
  def create
    join_group = current_user.join_groups.new(group_id: params[:group_id])
    join_group.role = :member
    if join_group.save
      flash[:notice] = "You successfully added"
      redirect_to groups_path
    else
      flash[:alert] = join_group.errors.full_messages.join(', ')
    end
  end
end