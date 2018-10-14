class DatasController < ApplicationController
  def index
    records = DataRecord.all
    render json: { status: 'SUCCESS', message: 'All current records in DB', data: records }, status: :ok
  end

  def show
    records = DataRecord.find_by(device_id: params[:device_id])
    if records
      render json: { status: 'SUCCESS', message: 'Current records for requested device', data: records }, status: :ok
    else
      render json: { status: 'ERROR', message: 'No record found for requested device' }, status: :not_found
    end
  end

  def show_type
    sensor_id = Sensor.find_by(sensorName: params[:data_type])
    if sensor_id
      records = DataRecord.find_by(device_id: params[:device_id], sensor_id: sensor_id)
      if records
        render json: { status: 'SUCCESS', message: 'Current records for requested device with this type', data: records }, status: :ok
      else
        render json: { status: 'ERROR', message: 'No record found for requested device with this type' }, status: :not_found
      end
    else
      render json: { status: 'ERROR', message: 'This data type does not exist' }, status: :not_found
    end
  end

  def create 
    sensor_id = Sensor.find_by(sensorName: params[:data_type])
    if sensor_id
      record = DataRecord.new( device_id: params[:device_id], timestamp: params[:timestamp], sensor_id: sensor_id.id, data: params[:data] )
      begin
        record.save
      rescue ActiveRecord::InvalidForeignKey => exception
        render json: { status: 'ERROR', message: 'This device does not exist', data: exception.message }, status: :not_found
      else
        if record.id
          render json: { status: 'SUCCESS', message: 'Record saved', data: record }, status: :ok
        else
          render json: { status: 'ERROR', message: 'Record save failed', data: record.errors }, status: :unprocessable_entity
        end
      end
    else
      render json: { status: 'ERROR', message: 'This data type does not exist' }, status: :not_found
    end
  end

  def destroy
    record = DataRecord.find(params[:id])
    if record 
      record.destroy
      render json: { status: 'SUCCESS', message: 'Record removed', data: record }, status: :ok
    else
      render json: { status: 'ERROR', message: 'Record not found' }, status: :not_found
    end
  end

end
