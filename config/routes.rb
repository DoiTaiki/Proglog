Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end
  root to: 'articles#index'
  resources :articles
end
