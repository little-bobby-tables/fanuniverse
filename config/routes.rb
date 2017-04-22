# frozen_string_literal: true
require 'sidekiq/web'

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

  resources :reports, only: [:new, :create]

  namespace :api do
    post 'stars/toggle'
  end

  authenticated :user, -> (u) { u.administrator? } do
    namespace :admin do
      get  'dashboard',           to: 'dashboard#show',      as: :dashboard

      get  'reports',             to: 'reports#index',       as: :reports
      post 'reports/resolve',     to: 'reports#resolve',     as: :resolve_report

      get  'images/merge',        to: 'images#merge',        as: :merge_images
      post 'images/commit_merge', to: 'images#commit_merge', as: :commit_image_merge

      mount Sidekiq::Web => '/sidekiq'
    end
  end

  PagesController::PAGES.each do |page|
    get page => 'pages#show', page: page
  end

  match '*catch_404', to: 'application#render_40x', via: :all
end
