Rails.application.routes.draw do
  
  # Sensors management
  resources :sensors

  # Users management
  resources :users

  # Devices management
  get 'devices' => 'devices#index'
  get 'devices/:user_id' => 'devices#show' # Get all the devices of the user
  post 'devices/:user_id' => 'devices#create'
  patch 'devices/:user_id/:device_id' => 'devices#update'
  delete 'devices/:user_id/:device_id' => 'devices#destroy'

end
