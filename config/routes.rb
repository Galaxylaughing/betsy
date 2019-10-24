Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # RESTful routes:
  root 'homepages#index'
  
  resources :users
  resources :products
  resources :orders
  resources :reviews 
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "callback"
  delete "/logout", to: "users#destroy", as: "logout"
  
end
