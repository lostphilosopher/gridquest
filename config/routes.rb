Rails.application.routes.draw do
  devise_for :users

  resources :games do
    member do
      get 'defeat'
    end
  end

  root to: 'index#index'
end
