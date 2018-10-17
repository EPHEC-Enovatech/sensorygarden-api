class User < ApplicationRecord
    has_secure_password
    has_many :devices, dependent: :destroy

    validates :nom, presence: true
    validates :prenom, presence: true
    validates :email, presence: true, uniqueness: true
end