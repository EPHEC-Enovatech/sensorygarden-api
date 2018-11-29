class UsersController < ApplicationController

    before_action :authenticate_user, except: [:create, :confirm_email, :send_reset_password, :reset_password]

    def index
        users = User.select(:nom, :prenom, :email).all
        render json: {status: "SUCCESS", message: "All users currently in DB", data: users}, status: :ok
    end

    def show
        if check_current_user(params[:id])
            user = User.select(:nom, :prenom, :email).find(params[:id])
            render json: {status: "SUCCESS", message: "User of requested Id", data: user}, status: :ok
        end
    end

    def create
        user = User.new(user_params)
        if user.save
            ContactMailer.user_signup(user).deliver
            render json: {status: "SUCCESS", message: "Vous avez bien été inscrit. Vérifiez votre boite mail pour confirmer votre compte.", data: user}, status: :ok
        else
            render json: {status: "ERROR", message: "Impossible de terminer l'inscription", data: user.errors}, status: :unprocessable_entity
        end 
    end

    def send_reset_password
        user = User.find_by(email: params[:email])
        if user
            user.regenerate_reset_token
            ContactMailer.password_reset(user).deliver
            render json: { status: 'SUCCESS', message: "Email de récupération de mot de passe envoyé !" }, status: :ok
        else
            render json: { status: 'ERROR', message: "Aucun utilisateur connu avec cet email" }, status: :not_found
        end
    end

    def promote_admin
        if check_current_isAdmin?
            user = User.find(params[:user_id])
            user.update_attributes(admin: true)
            render json: { status: 'SUCCESS', message: "User #{params[:user_id]} promoted !" }, status: :ok
        end
    end

    def update
        if check_current_user(params[:id])
            user = User.find(params[:id])
            user.update_attributes(update_params)
            render json: {status: "SUCCESS", message: "Informations mises à jour", data: user}, status: :ok
        end
    end

    def reset_password
        user = User.find_by(reset_token: params[:token])
        if user 
            check_password_change(user)
        else
            render json: { status: "ERROR", message: "Le token est incorrecte !" }, status: :not_found
        end
    end

    def confirm_email
        user = User.find_by(confirm_token: params[:token])
        if user
            user.update_attributes(confirm_email: true)
            render json: { status: "SUCCESS", message: "Votre email a été confirmé" }, status: :ok
        else
            render json: { status: "ERROR", message: "Le token est invalide" }, status: :not_found
        end
    end

    def change_password
        if check_current_user(params[:user_id])
            user = User.find(params[:user_id])
            if user 
                if user.authenticate(params[:old_password])
                    check_password_change(user)
                else
                    render json: { status: 'ERROR', message: "L'ancien mot de passe est incorrecte" }, status: :unprocessable_entity
                end
            end
        end
    end

    def destroy
        if check_current_user(params[:id])
            user = User.find(params[:id])
            user.destroy
            render json: {status: "SUCCESS", message: "User deleted", data: user}, status: :ok
        end
    end

    private 

    def user_params
        params.permit(:nom, :prenom, :email, :password, :password_confirmation)
    end

    def update_params
        params.permit(:nom, :prenom, :email)
    end

    def password_params
        params.permit(:password, :password_confirmation)
    end

    def check_password_change(user)
        if user.update_attributes(password_params)
            render json: { status: "SUCCESS", message: "Le mot de passe a été correctement mis à jour" }, status: :ok
        else
            render json: { status: "ERROR", message: "Erreur de modification", data: user.errors }, status: :unprocessable_entity
        end
    end
end