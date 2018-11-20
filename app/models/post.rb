class Post < ApplicationRecord
    has_many :categories_posts
    has_many :categories, through: :categories_posts
    has_many :comments, through: :comments_posts

    validates :postTitle, presence: true
    validates :postText, presence: true
end