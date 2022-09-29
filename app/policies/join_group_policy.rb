class JoinGroupPolicy < ApplicationPolicy

  def approve?
    admin? || moderator?
  end

  def remove?
    admin? || moderator?
  end

  def leave?
    record.user == user
  end

  def cancel?
    record.user == user
  end

  def edit?
    record.user == user
  end

  def update?
    admin? || moderator?
  end

  def admin?
    user.join_groups.find_by(group: record.group).admin?
  end

  def moderator?
    user.join_groups.find_by(group: record.group).moderator?
  end
end