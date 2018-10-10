Rails.application.routes.draw do
  
  # Sensors management
  resources :sensors

  # Users management
  resources :users

  # Devices management
  get 'devices' => 'devices#index'
  get 'devices/:user_id' => 'devices#show'
  post 'devices/:user_id' => 'devices#create'
  patch 'devices/:user_id/:id' => 'devices#update'
  delete 'devices/:user_id/:id' => 'devices#destroy'

end
