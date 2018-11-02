class DevicesController < ApplicationController

    before_action :authenticate_user

    def index
        devices = Device.all
        render json: { status: "SUCCESS", message: "All devices currently in DB", data: devices }, status: :ok
    end

    def show
        devices = Device.find_by(user_id: params[:user_id])
        if devices
            render json: { status: "SUCCESS", message: "All devices currently assigned to requested user", data: devices }, status: :ok
        else
            render json: { status: "ERROR", message: "No device found for requested user" }, status: :not_found
        end
    end

    def create
        device = Device.new(device_params)
        begin
            device.save
        rescue ActiveRecord::NotNullViolation => exception
            render json: { status: 'ERROR', message: 'Saving failed: Missing deviceName value', data: exception.message }, status: :unprocessable_entity
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
            if device.update_attributes(device_params)
                render json: { status: "SUCCESS", message: "Device updated", data: device }, status: :ok
            else
                render json: { status: "ERROR", message: "Device update failed", data: device.errors }, status: :unprocessable_entity
            end
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

end