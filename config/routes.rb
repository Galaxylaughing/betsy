Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # RESTful routes:
  root 'homepages#index'
  
  resources :users, only: [:index, :show]
  get '/users/:id/dashboard', to: "users#dashboard", as: "dashboard"
  
  resources :users do
    resources :products, only: [:show]
  end 
  
  resources :categories do 
    resources :products, only: [:show]
  end 
  
  resources :products do 
    resources :order_items, only: [:create, :destroy, :update]
  end 
  
  resources :products do
    resources :reviews, only: [:new, :create, :show, :index]
  end

  resources :orders
  resources :reviews 
  resources :order_items, only: [:create, :show, :destroy]

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "callback"
  delete "/logout", to: "users#destroy", as: "logout"
  
  # post '/order_items/', to: 'order_items#create'
  post '/order_items/:id/', to: 'order_items#complete', as: "mark_complete"
  
  get "/log_in", to: "users#login_form", as: "log_in"
  post "/log_in", to: "users#login"
  post "/log_out", to: "users#logout", as: "log_out"
end
