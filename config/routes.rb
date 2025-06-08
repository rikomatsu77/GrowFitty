Rails.application.routes.draw do
  root "static_pages#top"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  namespace :members do
    resource :mypage, only: [:show, :edit, :update]
    resources :children
  end

  get "predictions/new", to: "predictions#new", as: :new_prediction
  post "predictions/create", to: "predictions#create", as: :create_prediction
  get "predictions/result", to: "predictions#result", as: :prediction_result

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
