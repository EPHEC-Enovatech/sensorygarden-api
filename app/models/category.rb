class Category < ApplicationRecord
    has_many :posts, through: :categories_posts

    validates :categoryName, presence: true
end