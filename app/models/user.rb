class User < ApplicationRecord
    has_many :posts, dependent: :destroy
    has_many :reactions, dependent: :destroy

    validates :email, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
end
