Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "callback"
  delete "/logout", to: "users#destroy", as: "logout"
end
