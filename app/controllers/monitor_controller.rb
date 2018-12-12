class MonitorController < ApplicationController

    def ping
        render json: { status: "SUCCESS", message: "Pong !" }, status: :ok
    end

end