Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  get '/guest_login', to: 'sessions#new_as_guest'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'twitter_sessions#create'
  get '/new_link_account', to: 'twitter_sessions#new_link_account'
  post '/new_link_account', to: 'twitter_sessions#create_link_account'
  root to: 'articles#index'
  resources :articles, :users
  resources :categories, only: [:show, :create, :edit, :update, :destroy]
end
