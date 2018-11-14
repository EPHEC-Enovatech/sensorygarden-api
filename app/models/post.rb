class Post < ApplicationRecord
    has_one :categories, dependent: :destroy

    validate :postTitle, presence: true
    validate :postText, presence: true,
    
end