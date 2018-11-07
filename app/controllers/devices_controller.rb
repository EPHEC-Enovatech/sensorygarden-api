class DevicesController < ApplicationController

    before_action :authenticate_user

    def index
        devices = Device.all
        render json: { status: "SUCCESS", message: "All devices currently in DB", data: devices }, status: :ok
    end

    def show
        devices = Device.where(user_id: params[:user_id]) 
        if !devices.blank?
            render json: { status: "SUCCESS", message: "All devices currently assigned to requested user", data: devices }, status: :ok
        else
            raise(ActiveRecord::RecordNotFound)
        end
    end

    def create
        return unless check_checksum(params[:checksum].to_i, params[:device_id])
        device = Device.new(device_params)
        begin
            device.save
        rescue ActiveRecord::InvalidForeignKey => exception
            render json: { status: 'ERROR', message: 'Saving failed: user_id does not exist', data: exception.message }, status: :not_found
        rescue ActiveRecord::RecordNotUnique => exception
        render json: { status: 'ERROR', message: 'Saving failed: device_id already exists', data: exception.message }, status: :unprocessable_entity
        else
            render json: { status: 'SUCCESS', message: "Device saved", data: device }, status: :ok
        end
    end

    def update
        device = Device.find_by(device_id: params[:id])
        if device
            device.update_attributes(device_params)
            render json: { status: "SUCCESS", message: "Device updated", data: device }, status: :ok
        else
            render json: { status: "ERROR", message: "No device found for requested user" }, status: :not_found
        end
    end

    def destroy
        device = Device.find_by(device_id: params[:id])
        if device
            device.destroy
            render json: { status: "SUCCESS", message: "Device deleted", data: device }, status: :ok
        else 
            render json: { status: "ERROR", message: "No device found for requested user" }, status: :not_found
        end
    end

    private

    def device_params
        params.permit(:user_id, :device_id, :deviceName)
    end

    def check_checksum(checksum, param)
        if checksum.blank? || param.blank?
            render json: { status: 'ERROR', message: "Missing device_id and/or checksum" }, status: :unprocessable_entity
            return false
        else
            if checksum === gen_checksum(param)
                return true
            else
                render json: { status: 'ERROR', message: "The verification code is incorrect"}, status: :unprocessable_entity
                return false
            end
        end
    end

    def gen_checksum(param)
        result = 0
        param.length.times do |i|
            result += param[i].ord*i+1
        end
        return result%97
    end

end