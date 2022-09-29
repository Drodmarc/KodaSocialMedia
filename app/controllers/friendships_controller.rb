class FriendshipsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_friendship, only: [:confirm, :unfriend, :ignore, :cancel]

  def index
    friendships = current_user.friendships.where.not(state: not_friend_states).includes(:friend)
    inverse_friendships = current_user.inverse_friendships.where.not(state: not_friend_states).includes(:user)
    merge_ids = friendships.pluck(:friend_id) + inverse_friendships.pluck(:user_id) << current_user.id
    @users = User.where.not(id: merge_ids) if params[:records].blank? || params[:records] == 'add'
    @all_friends = friendships.confirmed + inverse_friendships.confirmed if params[:records] == 'all'
    @friend_requests = current_user.inverse_friendships.pending.order(id: :desc) if params[:records] == 'request'
    @sent_requests = current_user.friendships.pending.order(id: :desc) if params[:records] == 'sent'
  end

  def create
    check_friends_relation = current_user.friendships.find_by(friend_id: params[:friend_id])
    check_inverse_friends_relation = current_user.inverse_friendships.find_by(user_id: params[:friend_id])
    if update_friendship = current_user.friendships.where(state: not_friend_states).find_by(friend_id: params[:friend_id])
      update_friendship.request!
      flash[:notice] = "You successfully added"
      redirect_to friendships_path
    elsif check_friends_relation.blank? ||  check_inverse_friends_relation.blank? && current_user.id != params[:friend_id].to_i
      friendship = current_user.friendships.new(friend_id: params[:friend_id])
      if friendship.save
        flash[:notice] = "You successfully added"
        redirect_to friendships_path
      else
        flash[:alert] = friendship.errors.full_messages.join(', ')
      end
    else
      flash[:alert] = "You Can't Add this user again!"
      redirect_to friendships_path
    end
  end

  def confirm
    authorize @friendship, :confirm?, policy_class: FriendshipPolicy
    if @friendship.confirm!
      flash[:notice] = "Confirm Successfully"
    else
      flash[:alert] = @friendship.errors.full_messages.join(', ')
    end
    redirect_to friendships_path(records: :request)
  end

  def unfriend
    authorize @friendship, :unfriend?, policy_class: FriendshipPolicy
    if @friendship.unfriend!
      flash[:notice] = "Unfriend Successfully"
    else
      flash[:alert] = @friendship.errors.full_messages.join(', ')
    end
    redirect_to friendships_path(records: :all)
  end

  def ignore
    authorize @friendship, :ignore?, policy_class: FriendshipPolicy
    if @friendship.ignore!
      flash[:notice] = "Ignore Successfully"
    else
      flash[:alert] = @friendship.errors.full_messages.join(', ')
    end
    redirect_to friendships_path(records: :request)
  end

  def cancel
    authorize @friendship, :cancel?, policy_class: FriendshipPolicy
    if @friendship.cancel!
      flash[:notice] = "Cancel Successfully"
    else
      flash[:alert] = @friendship.errors.full_messages.join(', ')
    end
    redirect_to friendships_path(records: :sent)
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:friendship_id])
  end

  def not_friend_states
    [:unfriended, :ignored, :cancelled]
  end
end