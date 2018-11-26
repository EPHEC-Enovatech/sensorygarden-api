class DevicesController < ApplicationController

    before_action :authenticate_user

    def index
        devices = Device.all
        render json: { status: "SUCCESS", message: "All devices currently in DB", data: devices }, status: :ok
    end

    def show
        if check_current_user(params[:user_id])
            devices = Device.where(user_id: params[:user_id]) 
            if !devices.blank?
                render json: { status: "SUCCESS", message: "All devices currently assigned to requested user", data: devices }, status: :ok
            else
                raise(ActiveRecord::RecordNotFound)
            end
        end
    end

    def create
        if check_current_user(params[:user_id])
            return unless check_checksum(params[:checksum].to_i, params[:device_id])
            device = Device.new(device_params)
            begin
                device.save
            rescue ActiveRecord::InvalidForeignKey => exception
                render json: { status: 'ERROR', message: 'Erreur : le user-id n\'existe pas', data: exception.message }, status: :not_found
            rescue ActiveRecord::RecordNotUnique => exception
                render json: { status: 'ERROR', message: 'Erreur : ce Sensory Captor existe déjà', data: exception.message }, status: :unprocessable_entity
            else
                render json: { status: 'SUCCESS', message: "Sauvegarde réussie !", data: device }, status: :ok
            end
        end
    end

    def update
        device = Device.find_by(device_id: params[:id])
        if device
            if check_current_user(device.user_id)
                device.update_attributes(device_params)
                render json: { status: "SUCCESS", message: "Device updated", data: device }, status: :ok
            end
        else
            render json: { status: "ERROR", message: "No device found for requested user" }, status: :not_found
        end
    end

    def destroy
        device = Device.find_by(device_id: params[:id])
        if device
            if check_current_user(device.user_id)
                device.destroy
                render json: { status: "SUCCESS", message: "Device deleted", data: device }, status: :ok
            end
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
            render json: { status: 'ERROR', message: "Erreur : Le numéro et/ou la vérification ne peuvent être vide" }, status: :unprocessable_entity
            return false
        else
            if checksum === gen_checksum(param)
                return true
            else
                render json: { status: 'ERROR', message: "Erreur : Le code de vérification est incorrecte"}, status: :unprocessable_entity
                return false
            end
        end
    end

    def gen_checksum(param)
        result = 0
        param.length.times do |i|
            result += param[i].ord*(i+1)
        end
        return result%97
    end

end