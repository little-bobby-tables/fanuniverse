Rails.application.routes.draw do
  devise_for :users
  root to: 'feed#index'

  resources :images, constraints: { id: /\d+/ }

  resources :users, param: :name, except: [:new, :create, :destroy]

  namespace :api do
    post 'rating_stars/toggle'
  end
end
