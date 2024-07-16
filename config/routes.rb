Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  resources :products, only: [:index, :show]
  get 'search', to: 'products#search', as: :search_products

  devise_for :customers, controllers: {
    registrations: 'customers/registrations',
    sessions: 'customers/sessions',
    passwords: 'customers/passwords'
  }

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get "up" => "rails/health#show", as: :rails_health_check

  # Routes for Cart
  resource :cart, only: [:show, :destroy] do
    post 'add_item', on: :collection
    patch 'update_item', on: :collection
    delete 'remove_item', on: :collection
    delete 'empty_cart', on: :collection  # Ensure this line is added
  end

  # Routes for Orders
  resources :orders, only: [:new, :create, :show]

  # Route for customer orders
  get 'customer/orders', to: 'customers#orders', as: :customer_orders
end
