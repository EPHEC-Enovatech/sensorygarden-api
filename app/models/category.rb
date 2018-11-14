class Category < ApplicationRecord
    validate :categoryName, presence: true
end