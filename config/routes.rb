Rails.application.routes.draw do
  root 'pages#home'
  resources :products, only: [:index, :show]
  get 'search', to: 'products#search', as: :search_products
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "up" => "rails/health#show", as: :rails_health_check
end
