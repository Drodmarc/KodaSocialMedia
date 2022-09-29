Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'

  resources :posts, except: :show do
    resources :comments, except: :show
  end
  resources :friendships, only: [:index, :create] do
    put :confirm, :unfriend, :ignore, :cancel
  end
  resources :groups
  resources :join_groups do
    put 'approve/:group_id', as: :approve, to: 'join_groups#approve'
    put :remove, :leave, :cancel
  end
end