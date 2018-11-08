class UsersController < ApplicationController

    before_action :authenticate_user, except: [:create]

    def index
        users = User.all
        render json: {status: "SUCCESS", message: "All users currently in DB", data: users}, status: :ok
    end

    def show
        user = User.find(params[:id])
        render json: {status: "SUCCESS", message: "User of requested Id", data: user}, status: :ok
    end

    def create
        user = User.new(user_params)
        if user.save
            render json: {status: "SUCCESS", message: "Vous avez bien été inscrit", data: user}, status: :ok
        else
            render json: {status: "ERROR", message: "Impossible de terminer l'inscription", data: user.errors}, status: :unprocessable_entity
        end 
    end

    def update
        user = User.find(params[:id])
        user.update_attributes(user_params)
        render json: {status: "SUCCESS", message: "Informations mises à jour", data: user}, status: :ok              
    end

    def destroy
        user = User.find(params[:id])
        user.destroy
        render json: {status: "SUCCESS", message: "User deleted", data: user}, status: :ok        
    end

    private 

    def user_params
        params.permit(:nom, :prenom, :email, :password, :password_confirmation)
    end

end