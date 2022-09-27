module ApplicationHelper
  def filter_post
    merge_friends_ids = current_user.friendships.confirmed.pluck(:friend_id) + current_user.inverse_friendships.confirmed.pluck(:user_id)
    only_me = current_user.posts
    to_all = Post.to_all
    friends = Post.where(user_id: merge_friends_ids).where.not(genre: :only_me)
    only_me + to_all + friends
  end
end