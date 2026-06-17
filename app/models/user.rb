class User < ApplicationRecord
    has_secure_password validations: false

    has_many :refresh_tokens, dependent: :destroy
    has_many :posts, dependent: :destroy
    has_many :reactions, dependent: :destroy
    has_many :stickers, dependent: :destroy

    belongs_to :profile_picture, class_name: "Medium", optional: true

    validates :email, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true

    validates :password, presence: true, length: { minimum: 6 }, if: :password_changed?

    private

    def password_changed?
        new_record? && password_digest.nil? || password.present?
    end
end
