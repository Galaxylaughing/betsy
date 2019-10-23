Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # RESTful routes:
  root to:'homepages#index'
  
  resources :users
  resources :products
  resources :orders
  resources :reviews  
end
