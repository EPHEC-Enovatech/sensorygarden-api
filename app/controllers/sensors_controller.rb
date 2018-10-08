class SensorsController < ApplicationController
  def index
    render :json => Sensor.all
  end

  def create
    Sensor.create sensorName: params[:sensorName], sensorUnit: params[:sensorUnit]
    render :json => "Record done".to_json
  end

  def destroy
    Sensor.find(params[:id]).destroy
    render :json => {:message => "Sensor deleted", :sensorId => params[:id]}
  end
end
