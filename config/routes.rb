Rails.application.routes.draw do
  devise_for :users
  root to: 'index#index', as: 'unauthenticated_root'

  authenticated :user do
    resources :games
    root to: 'games#index', as: 'authenticated_root'
  end
end
