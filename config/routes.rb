Rails.application.routes.draw do
  root "static_pages#top"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks",
    passwords: "users/passwords"
  }

  namespace :members do
    resource :mypage, only: [:show, :edit, :update]
    resources :children, except: [:show]
  end

  resources :posts, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    resources :comments, only: [:create, :show, :edit, :update, :destroy], shallow: true
    collection do
      get :bookmarks
      get :tags
    end
  end

  resources :bookmarks, only: [:create, :destroy]

  get "predictions/new", to: "predictions#new", as: :new_prediction
  post "predictions/create", to: "predictions#create", as: :create_prediction
  get "predictions/result", to: "predictions#result", as: :prediction_result
  post "members/predictions/create", to: "members/predictions#create", as: :members_create_prediction
  get "members/predictions/result", to: "members/predictions#result", as: :members_prediction_result

  post "/callback", to: "line_bot#callback"

  get "/terms", to: "static_pages#terms"
  get "/privacy", to: "static_pages#privacy"
  get "contact", to: "contacts#new"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
