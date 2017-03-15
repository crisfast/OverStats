Rails.application.routes.draw do
  devise_for :users

  root "pages#home"
  
  
  resources :profiles
  resources :search
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
