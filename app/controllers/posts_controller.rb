class PostsController < ApplicationController
    def index
        posts = Post.all.to_json(:include => :categories)
        render json: { status: 'SUCCESS', message: 'All current posts in database', data: JSON.parse(posts) }, status: :ok
    end

    def show
        post = Post.find(params[:id]).to_json(:include => :categories)
        render json: { status: 'SUCCESS', message: "Post #{params[:id]}", data: JSON.parse(post) }, status: :ok
    end

    def create
        post = Post.new(posts_params)
        params[:categories].each do |id|
            post.categories << Category.find(id)
        end
        begin
            if post.save 
                render json: { status: 'SUCCESS', message: 'Post created', data: post }, status: :created
            else
                render json: { status: 'ERROR', message: 'Post creation failed', data: post.errors }, status: :unprocessable_entity
            end
        rescue ActiveRecord::InvalidForeignKey => exception
            render json: { status: 'ERROR', message: 'Error: the user_id does not exist', data: exception.message }, status: :unprocessable_entity 
        end
    end

    def update
        post = Post.find(params[:id])
        post.update_attributes(change_params)
        render json: { status: 'SUCCESS', message: 'Post updated', data: post }, status: :ok
    end

    def destroy
        post = Post.find(params[:id])
        post.destroy
        render json: { status: 'SUCCESS', message: 'Post deleted', data: post }, status: :ok
    end

    private

    def posts_params
        params[:postDate] = DateTime.now
        params.permit(:postTitle, :postText, :user_id, :postDate)
    end

    def change_params
        params.permit(:postTitle, :postText)
    end
end