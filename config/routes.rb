Rails.application.routes.draw do
  
  post 'user_token' => 'user_token#create'
  # Sensors management
  resources :sensors

  # Users management
  resources :users

  # Devices management
  get 'devices' => 'devices#index'
  get 'devices/:user_id' => 'devices#show' # Get all the devices of the user
  post 'devices/:user_id' => 'devices#create'
  patch 'devices/:id' => 'devices#update'
  delete 'devices/:id' => 'devices#destroy'


  # Data records management
  get 'records' => 'datas#index'
  get 'records/:device_id' => 'datas#show'
  get 'records/:device_id/:data_type' => 'datas#show_type'
  post 'records/:data_type' => 'datas#create'
  delete 'records/:id' => 'datas#destroy'

end
