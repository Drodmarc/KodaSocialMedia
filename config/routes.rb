Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'

  resources :posts, except: :show do
    resources :comments, except: :show
  end
  resources :friendships, only: [:index, :create] do
    put :confirm, :unfriend, :ignore, :cancel
  end
end
