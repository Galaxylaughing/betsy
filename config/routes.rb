Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # RESTful routes:
  root 'homepages#index'
  
  resources :users, only: [:index, :show]
  get '/users/:id/dashboard', to: "users#dashboard", as: "dashboard"
  
  resources :categories do 
    resources :products, only: [:show]
  end 
  
  resources :products do 
    resources :order_items, only: [:create, :destroy, :update]
    resources :reviews, only: [:new, :create, :show, :index]
  end
  
  resources :orders
  resources :reviews 
  resources :order_items, only: [:create, :show, :destroy]
  
  #retiring a product on merchant view
  patch 'product/:id/retire', to: 'products#toggle_retire', as: 'retired'
  
  get "/orders/:id/checkout", to: "orders#checkout_show", as: "checkout_show" 
  
  # oath login and logout paths
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "callback"
  delete "/logout", to: "users#destroy", as: "logout"
  
  post '/order_items/:id/', to: 'order_items#complete', as: "mark_complete"
  
  get '/register', to: 'homepages#register', as: "register_account"
  get '/about', to: 'homepages#about', as: "about"
end
