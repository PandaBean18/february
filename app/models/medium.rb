class Medium < ApplicationRecord
    self.table_name = "media"

    has_one :sticker, dependent: :destroy
    has_one :user, foreign_key: :profile_picture_id, dependent: :nullify

    validates :media_type, presence: true
    validates :cloudinary_public_id, presence: true

    enum :media_type, {
        sticker: "sticker",
        profile_picture: "profile_picture"
    }, default: :sticker

    def cloudinary_url
        Cloudinary::Utils.cloudinary_url(
            cloudinary_public_id,
            secure: true,
            transformation: [ { quality: "auto", fetch_format: "auto" } ]
        )
    end
end
