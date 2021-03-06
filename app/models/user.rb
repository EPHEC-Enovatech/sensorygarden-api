class User < ApplicationRecord
    has_secure_password
    has_secure_token :reset_token
    has_secure_token :confirm_token

    has_many :devices, dependent: :destroy
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy

    validates :nom, presence: true
    validates :prenom, presence: true
    validates :email, presence: true, uniqueness: true
    # validates :admin, presence: true

    def self.from_token_request request
        email = request.params['auth'] && request.params['auth']['email']
        user = self.find_by email: email
        return nil unless !user.blank? && user.confirm_email
        return user
    end

    def isAdmin?
        return self.admin
    end

    def to_token_payload
        { sub: self.id, admin: self.isAdmin? }
    end
end