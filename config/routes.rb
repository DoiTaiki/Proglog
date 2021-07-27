Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'twitter_sessions#create'
  get '/new_link_account', to: 'twitter_sessions#new_link_account'
  post '/new_link_account', to: 'twitter_sessions#create_link_account'
  root to: 'articles#index'
  resources :articles
  resources :users
end
