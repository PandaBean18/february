class Reaction < ApplicationRecord
    belongs_to :user
    belongs_to :post

    validates :reaction_type, presence: true
    validates :user_id, uniqueness: { scope: :post_id, message: "already reacted to this post" }
end
