class CategoriesController < ApplicationController

    before_action :authenticate_user

    def index
        render json: { status: 'SUCCESS', message: "All current catogries in database", data: Category.all }, status: :ok
    end

    def create
        category = Category.new(categories_params)
        if category.save
            render json: { status: 'SUCCESS', message: 'New category created', data: category }, status: :created
        else
            render json: { status: 'ERROR', message: 'Category creation failed', data: category.errors }, status: :unprocessable_entity
        end
    end

    def update
        category = Category.find(params[:id])
        if category.update_attributes(categories_params)
            render json: { status: 'SUCCESS', message: 'Category updated', data: category }, status: :ok
        else
            render json: { status: 'ERROR', message: 'Category update failed', data: category.errors }, status: :unprocessable_entity
        end
    end

    def destroy
        category = Category.find(params[:id])
        category.destroy
        render json: { status: 'SUCCESS', message: 'Category deleted', data: category }, status: :ok        
    end

    private 

    def categories_params
        params.permit(:categoryName)
    end
end