Rails.application.routes.draw do
  devise_for :users
  root to: 'feed#index'

  resources :images, constraints: { id: /\d+/ }

  resources :users, param: :name, except: [:new, :create, :destroy]

  resources :comments, except: [:new]

  namespace :api do
    post 'stars/toggle'
  end
end
