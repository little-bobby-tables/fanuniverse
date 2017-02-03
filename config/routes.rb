Rails.application.routes.draw do
  root to: 'feed#index'

  resources :images, constraints: { id: /\d+/ }
end
