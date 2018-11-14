class Post < ApplicationRecord
    has_one :categories, dependent: :destroy
    has_many :comments, through: :comments_posts

    validates :postTitle, presence: true
    validates :postText, presence: true,
    
end