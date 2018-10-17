class SensorsController < ApplicationController

  before_action :authenticate_user

  def index
    sensors = Sensor.all
    render json: { status: 'SUCCESS', message: 'Current sensors available', data: sensors }, status: :ok
  end

  def show
    sensor = Sensor.find(params[:id])
    render json: { status: 'SUCCESS', message: 'Sensor of requested Id', data: sensor }, status: :ok
  end

  def create 
    sensor = Sensor.new(sensor_params)
    if sensor.save
      render json: { status: 'SUCCESS', message: 'Saved new Sensor', data: sensor }, status: :ok
    else 
      render json: { status: 'ERROR', message: 'Sensor not saved', data: sensor.errors }, status: :unprocessable_entity
    end
  end

  def update
    sensor = Sensor.find(params[:id])
    if sensor.update_attributes(sensor_params)
      render json: { status: 'SUCCESS', message: 'Sensor updated', data: sensor }, status: :ok
    else
      render json: { status: 'ERROR', message: 'Sensor update failed', data: sensor.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    sensor = Sensor.find(params[:id])
    sensor.destroy
    render json: { status: 'SUCCESS', message: 'Sensor delete', data: sensor }, status: :ok
  end


  private 

  def sensor_params
    params.permit(:sensorName, :sensorUnit)
  end

end
