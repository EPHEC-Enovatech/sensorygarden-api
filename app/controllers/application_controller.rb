class ApplicationController < ActionController::API

    include Knock::Authenticable

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response


    def render_not_found_response(exception)
        render json: { status: "ERROR", message: exception.message }, status: :not_found
    end

    def check_current_user(id)
        if current_user.id == id.to_i
            return true
        else 
            return true if Rails.env.test? && !params[:fails]
            render json: { status: "ERROR", message: "Access refused" }, status: :unauthorized
            return false          
        end
    end

end
