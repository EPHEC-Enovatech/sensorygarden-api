Rails.application.routes.draw do
  
  # Sensors managment
  resources :sensors

  # Users managment
  resources :users

  # Devices managment
  resources :devices

end
