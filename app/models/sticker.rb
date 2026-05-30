class Sticker < ApplicationRecord
    belongs_to :medium
    belongs_to :user
    has_many :post_stickers, dependent: :destroy

    validates :medium, presence: true
    validates :user, presence: true
    validates :name, presence: true

    def cloudinary_url
        medium.cloudinary_url
    end
end
