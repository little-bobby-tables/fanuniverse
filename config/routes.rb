Rails.application.routes.draw do
  devise_for :users

  root to: 'images#index'

  resources :images, constraints: { id: /\d+/ } do
    member do
      get 'history'
    end
  end

  resources :profiles, param: :name, only: [:show]
  authenticated :user do
    resource :profile, only: [:edit, :update]
  end

  resources :comments, except: [:new]

  namespace :api do
    get 'image_scraping/scrape'
    post 'stars/toggle'
  end

  match '*catch_404', to: 'application#render_40x', via: :all
end
