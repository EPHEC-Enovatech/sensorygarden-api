class CommentsController < ApplicationController

    before_action :authenticate_user

    def index
        render json: { status: 'SUCCESS', message: 'All comments currently in database', data: Comment.all }, status: :ok
    end

    def show
        comment = Comment.find(params[:id])
        render json: { status: 'SUCCESS', message: "Comment #{params[:id]}", data: comment }, status: :ok
    end

    def create
        comment = Comment.new(comments_params)
        begin
            comment.save
            render json: { status: 'SUCCESS', message: 'Comment created', data: comment }, status: :created
        rescue ActiveRecord::NotNullViolation => exception
            render json: { status: 'ERROR', message: 'user_id or post_id can not be null', data: exception.message }, status: :unprocessable_entity
        rescue ActiveRecord::InvalidForeignKey => exception
            render json: { status: 'ERROR', message: 'user_id or post_id does not exist', data: exception.message }, status: :unprocessable_entity
        end
        
    end

    def update
        comment = Comment.find(params[:id])
        comment.update_attributes(change_params)
        render json: { status: 'SUCCESS', message: 'Comment updated', data: comment }, status: :ok
    end

    def destroy
        comment = Comment.find(params[:id])
        comment.destroy
        render json: { status: 'SUCCESS', message: 'Comment deleted', data: comment }, status: :ok
    end

    private 

    def comments_params
        params[:commentDate] = DateTime.now
        params.permit(:commentText, :user_id, :post_id, :commentDate)
    end

    def change_params
        params.permit(:commentText)
    end
end