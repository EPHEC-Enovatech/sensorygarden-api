class DatasController < ApplicationController

  before_action :authenticate_user, except: [:create]

  def index
    records = DataRecord.all
    render json: { status: 'SUCCESS', message: 'All current records in DB', data: records }, status: :ok
  end

  def show
    records = DataRecord.where(device_id: params[:device_id])
    check_record_blank(
      records, 
      'Current records for requested device', 
      'No record found for requested device' 
    )
  end

  def show_type
    return unless sensor_id = get_sensor_id(params[:data_type])
    records = DataRecord.where(device_id: params[:device_id], sensor_id: sensor_id)
    check_record_blank(
      records,
      'Current records for requested device with this type',
      'No record found for requested device with this type'
    )
  end

  def show_date
    return unless sensor_id = get_sensor_id(params[:data_type])
    date = Date.strptime(params[:date], '%d-%m-%Y')
    records = DataRecord.where(device_id: params[:device_id], sensor_id: sensor_id, timestamp: (date.midnight)..(date.midnight+1.day))
    check_record_blank(
      records,
      'Current records for requested device with this type and for requested day',
      'No record found for requested device with this type and for requested day'
    )
  end

  def show_range
    return unless sensor_id = get_sensor_id(params[:data_type])
    start_date = Date.strptime(params[:start_date], '%d-%m-%Y')
    end_date = Date.strptime(params[:end_date], '%d-%m-%Y')
    records = DataRecord.where(device_id: params[:device_id], sensor_id: sensor_id, timestamp: (start_date.midnight)..(end_date.midnight+1.day))
    check_record_blank(
      records,
      'Current records for requested device with this type and for requested day',
      'No record found for requested device with this type and for requested day'
    )
  end

  def get_last_record_date
    timestamp = DataRecord.where(device_id: params[:device_id]).order("timestamp").select(:id, :timestamp).last
    check_record_blank(
      timestamp,
      'Timestamp of the last record for requested device',
      'No records found for requested device'
    )
  end

  def create
    logger.info params
    return unless sensor_id = get_sensor_id(params[:data_type])
    record = DataRecord.new( device_id: params[:device_id], timestamp: DateTime.now, sensor_id: sensor_id.id, data: params[:data] )
    begin
      record.save
    rescue ActiveRecord::InvalidForeignKey => exception
      render json: { status: 'ERROR', message: 'This device does not exist', data: exception.message }, status: :not_found
    else
      check_record_success(record)
    end
  end

  def destroy
    record = DataRecord.find(params[:id])
    record.destroy
    render json: { status: 'SUCCESS', message: 'Record removed', data: record }, status: :ok
  end

  private 

  def get_sensor_id(sensor_name)
    sensor_id = Sensor.find_by(sensorName: sensor_name)
    if sensor_id
      return sensor_id
    else
      render json: { status: 'ERROR', message: 'This data type does not exist' }, status: :not_found
      return false
    end
  end

  def check_record_success(record)
    if record.id
      render json: { status: 'SUCCESS', message: 'Record saved', data: record }, status: :ok
    else
      render json: { status: 'ERROR', message: 'Record save failed', data: record.errors }, status: :unprocessable_entity
    end
  end

  def check_record_blank(records, success, failure)
    if !records.blank?
      render json: { status: 'SUCCESS', message: success, data: records }, status: :ok
    else
      render json: { status: 'ERROR', message: failure }, status: :not_found
    end
  end

end
