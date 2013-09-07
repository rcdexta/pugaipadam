PugaipadamRails4::Application.routes.draw do
  
  resources :wall, only: [:index]
  resources :consultants, only: [:index, :edit, :update, :show]
  resources :activity, only: [:index]

  root :to => 'wall#index'

end
