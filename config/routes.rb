Rails.application.routes.draw do
  devise_for :users
  root to: 'feed#index'

  resources :images, constraints: { id: /\d+/ }
end
