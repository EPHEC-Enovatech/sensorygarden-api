class Post < ApplicationRecord
    has_many :categories_posts
    has_many :categories, through: :categories_posts
    has_many :comments, dependent: :destroy
    belongs_to :user

    validates :postTitle, presence: true
    validates :postText, presence: true
end