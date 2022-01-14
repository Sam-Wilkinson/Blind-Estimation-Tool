Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#home'
  get 'home', to: 'static_pages#home'
  get 'help', to: 'static_pages#help'
  get 'about', to: 'static_pages#about'
  resources :rooms
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end