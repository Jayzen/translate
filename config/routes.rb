Rails.application.routes.draw do
  root 'words#index'
  get "words/lists", to: "words#lists"
  resources :words do
    get 'search', on: :collection
    get 'interpret', on: :collection
    get 'status', on: :member
    get 'unfamiliar', on: :collection
    get 'tags', on: :collection
  end
  get  '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get "/auth/:provider/callback" => "sessions#create"
  delete '/logout',  to: 'sessions#destroy'
  resources :users, :password_alters, :set_templates, :set_modules, only: [:edit, :update]
  resources :portraits, only: [:new, :create, :update] 
  resources :tags
end
