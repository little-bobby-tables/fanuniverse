# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users

  root to: 'images#index'

  constraints sort: ImagesHelper::IMAGE_SORTS_CONSTRAINT do
    get '/images(/:sort)', to: 'images#index', as: :images
  end

  resources :images, only: [:show, :new, :edit, :create, :update], constraints: { id: /\d+/ } do
    member do
      get 'navigate/:direction', action: :navigate, as: :navigate
      get 'history'
    end
  end

  resources :profiles, param: :name, only: [:show]

  authenticated :user do
    resource :profile, only: [:edit, :update]
  end

  resources :comments, except: [:new]

  resources :reports, only: [:index, :new, :create] do
    member do
      post 'resolve', as: :resolve
    end
  end

  namespace :api do
    get 'image_scraping/scrape'
    post 'stars/toggle'
  end

  PagesController::PAGES.each do |page|
    get page => 'pages#show', page: page
  end

  match '*catch_404', to: 'application#render_40x', via: :all
end
