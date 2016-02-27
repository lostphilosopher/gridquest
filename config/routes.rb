Rails.application.routes.draw do
  devise_for :users

  resources :games do
    member do
      get 'victory'
      get 'defeat'
    end
  end

  resources :grids
  resources :descriptions
  resources :boxes
  resources :npcs
  resources :items

  get '/admin', to: 'admin#index'

  root to: 'index#index'
end
