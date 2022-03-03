Rails.application.routes.draw do
  get 'sessions/new'
  root "tasks#index"
  resources :tasks
  resources :users, only: %i[ new create show ]
  resources :sessions, only: %i[ new create destroy ]

  namespace :admin do
    resources :users
  end
end
