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

  get 'pages/index'
  get 'pages/help'
  get 'pages/contact'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
