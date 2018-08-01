Rails.application.routes.draw do
  # get 'products/new'
  # get 'products/edit'
  # get 'products/show'
  # get 'products/index'
  # get 'customers/new'
  # get 'customers/edit'
  # get 'customers/show'
  # get 'customers/index'
  # get 'users/new'
  # get 'users/edit'
  # get 'users/show'

  # resourcesによるルーティング
  resources :users
  resources :customers
  resources :products

  # session関連ルーティング
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/login_customer', to: 'sessions#new_customer'
  post '/login_customer', to: 'sessions#create_customer'
  delete '/logout_customer', to: 'sessions#destroy_customer'

  get 'pages/index'
  get 'pages/help'
  get 'pages/contact'

  root "pages#index"
end
