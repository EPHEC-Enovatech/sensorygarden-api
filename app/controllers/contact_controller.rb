class ContactController < ApplicationController

    def send_contact_demand
        @contact_params = contact_params
        if @contact_params.has_key?(:nom) && @contact_params.has_key?(:email) && @contact_params.has_key?(:message)
            ContactMailer.contact_demand(@contact_params).deliver
            render json: { status: 'SUCCESS', message: 'Email successfuly sent !'}, status: :ok
        else
            render json: { status: 'ERROR', message: 'Missing parameter', debug: @contact_params }, status: :unprocessable_entity
        end
    end

    private

    def contact_params
        params.permit(:nom, :email, :message)
    end

end