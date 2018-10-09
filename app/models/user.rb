class User < ApplicationRecord
    has_many :devices

    validates :nom, presence: true
    validates :prenom, presence: true
    validates :mail, presence: true, uniqueness: true
end