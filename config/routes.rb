Rails.application.routes.draw do
  devise_for :users

  root 'index#index'

  authenticate :user do
    resources :games
  end
end
