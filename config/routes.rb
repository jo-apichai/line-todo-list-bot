Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:index]
    end
  end

  resources :webhooks, only: :create

  get '/auth', to: 'authentications#index'

  root 'home#index'
end
