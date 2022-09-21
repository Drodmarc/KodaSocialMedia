class FriendshipPolicy < ApplicationPolicy
  def ignore?
    user == record.friend
  end

  def confirm?
    user == record.friend
  end

  def cancel?
    user == record.user
  end

  def unfriend?
    user == record.user || user == record.friend
  end
end