class Comment < ApplicationRecord
    has_one :posts, through: :comments_posts
    has_one :users, dependent: :destroy
    
    validates :commentText, presence: true
end