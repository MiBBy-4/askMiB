# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  concern :commentable do
    resources :comments, only: %i[create destroy]
  end

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    root 'pages#index'
    resources :questions, concerns: :commentable do
      resources :answers, except: %i[new show]
    end
    resources :answers, except: %i[new show], concerns: :commentable
    resources :users, only: %i[new create edit update]
    resource :session, only: %i[new create destroy]

    namespace :admin do
      resources :users, only: %i[index create edit update destroy]
    end

    resource :password_reset, only: %i[new create edit update]
  end
end
