# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    root 'pages#index'
    resources :questions do
      resources :comments, only: %i[create destroy]
      resources :answers, except: %i[new show]
    end
    resources :answers, except: %i[new show] do
      resources :comments, only: %i[create destroy]
    end
    resources :users, only: %i[new create edit update]
    resource :session, only: %i[new create destroy]

    namespace :admin do
      resources :users, only: %i[index create]
    end
  end
end
