Rails.application.routes.draw do
  resources :webhooks, only: :create

  root 'home#index'
end
