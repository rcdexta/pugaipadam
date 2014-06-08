PugaipadamRails4::Application.routes.draw do

  devise_for :consultants

  resources :wall, only: [:index]
  resources :dashboard, only: [:index]
  resources :consultants, only: [:index, :edit, :update, :show]
  resources :activity, only: [:index]

  root :to => 'wall#index'

end
