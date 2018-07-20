Rails.application.routes.draw do
  get 'companies/new'
  root 'home#index'
  devise_for :users, controllers: { sessions: 'users/sessions' }
  resources :companies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
