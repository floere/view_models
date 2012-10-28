Rails.application.routes.draw do
  resources :users, :only => [:show]
  resources :heroes, :only => [:show]
end