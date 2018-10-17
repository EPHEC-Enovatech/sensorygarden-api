class ApplicationController < ActionController::API

    include Knock::Authenticable

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response


    def render_not_found_response(exception)
        render json: { status: "ERROR", message: exception.message }, status: :not_found
    end

end
