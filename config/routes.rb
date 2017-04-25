Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
<<<<<<< HEAD
  
=======
>>>>>>> tuto-base
  devise_for :users
  root to: 'rooms#index'

  resources :rooms, only: [:index, :show, :new, :create] do
    resources :messages, only: [:create]
  end
end
