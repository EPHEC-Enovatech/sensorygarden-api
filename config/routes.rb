Rails.application.routes.draw do
  
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
  post 'records/:device_id/:data_type/:data' => 'datas#create'
  delete 'records/:id' => 'datas#destroy'

end
