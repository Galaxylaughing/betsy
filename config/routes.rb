Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # RESTful routes:
  root 'homepages#index'
  
  resources :users, only: [:index, :show, :edit]
  get '/users/:id/dashboard', to: "users#dashboard", as: "dashboard"
  
  resources :users do
    resources :products, only: [:show]
  end 
  
  resources :categories do 
    resources :products, only: [:show]
  end 
  
  resources :products
  resources :orders
  resources :reviews 
  resources :order_items, only: [:create, :destroy, :update]
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "callback"
  delete "/logout", to: "users#destroy", as: "logout"
  
  post '/order_items/', to: 'order_items#create'
  
end
