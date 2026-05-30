class PostSticker < ApplicationRecord
    belongs_to :post
    belongs_to :sticker
end
