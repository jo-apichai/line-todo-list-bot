Rails.application.routes.draw do
  resources :webhooks, only: :create

  get '/auth', to: 'authentications#index'

  root 'home#index'
end
