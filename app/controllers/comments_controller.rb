class CommentsController < ApplicationController

    before_action :authenticate_user, except: [:index, :show]

    def index
        render json: { status: 'SUCCESS', message: 'All comments currently in database', data: Comment.all }, status: :ok
    end

    def show
        comment = Comment.find(params[:id])
        render json: { status: 'SUCCESS', message: "Comment #{params[:id]}", data: comment }, status: :ok
    end

    def create
        comment = Comment.new(comments_params)
        comment.post = Post.find(params[:post_id])
        comment.user = User.find(params[:user_id])
        comment.save
        render json: { status: 'SUCCESS', message: 'Comment created', data: comment }, status: :created
    end

    def update
        if check_current_isAdmin?
            comment = Comment.find(params[:id])
            comment.update_attributes(change_params)
            render json: { status: 'SUCCESS', message: 'Comment updated', data: comment }, status: :ok
        end
    end

    def destroy
        if check_current_isAdmin?
            comment = Comment.find(params[:id])
            comment.destroy
            render json: { status: 'SUCCESS', message: 'Comment deleted', data: comment }, status: :ok
        end
    end

    private 

    def comments_params
        params[:commentDate] = DateTime.now
        params.permit(:commentText, :commentDate)
    end

    def change_params
        params.permit(:commentText)
    end
end