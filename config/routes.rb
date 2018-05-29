Rails.application.routes.draw do
  resources :webhooks, only: :create
end
