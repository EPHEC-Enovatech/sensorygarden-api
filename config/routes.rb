Rails.application.routes.draw do
  
  # Sensors
  get 'sensors' => 'sensors#index'
  post 'sensor' => 'sensors#create'
  delete 'sensor/:id' => 'sensors#destroy'

  # Datas
  get 'datas' => 'datas#index'
  post 'data' => 'data#create'
  delete 'data/:id' => 'data#destroy'

end
