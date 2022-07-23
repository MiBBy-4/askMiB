# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'pages#index'
  resources :questions do
    resources :answers, except: %i[new show]
  end
  resources :users, only: %i[new create edit update]
  resource :session, only: %i[new create destroy]

  namespace :admin do
    resources :users, only: [:index, :create]
  end
end
