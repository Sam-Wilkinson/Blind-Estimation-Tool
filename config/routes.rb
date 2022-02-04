Rails.application.routes.draw do

  devise_for :users
  root 'static_pages#home'
  get 'home', to: 'static_pages#home'
  get 'help', to: 'static_pages#help'
  get 'about', to: 'static_pages#about'
  resources :rooms
  post 'rooms/:id/join', to: 'room_users#join', as: 'join_room'
  delete 'rooms/:id/leave', to: 'room_users#leave', as: 'leave_room'
  delete 'rooms/:id/kick', to: 'room_users#kick', as: 'kick_user_room'
  resources :estimations
  resources :estimation_values
  resources :user_stories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end