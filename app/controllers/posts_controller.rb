class PostsController < ApplicationController
    def index
        render json: { status: 'SUCCESS', message: 'All current posts in database', data: Post.all }, status: :ok
    end

    def show
        post = Post.find(params[:id])
        render json: { status: 'SUCCESS', message: "Post #{params[:id]}", data: post }, status: :ok
    end

    def create
        post = Post.new(posts_params)
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

    def add_categs
        if params[:categories].blank?
            render json: { status: 'ERROR', message: 'No categories passed' }, status: :unprocessable_entity
        else
            Post.find(params[:id])
            categ = []
            params[:categories].each do |category|
                categ.push({ post_id: params[:id], category_id: category })
            end
            categories = CategoriesPost.create(categ)
            render json: { status: 'SUCCESS', message: 'Categories added', data: categories }, status: :created
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