class Post < ApplicationRecord
    belongs_to :user
    has_many :reaction, dependent: :destroy
    has_many :post_stickers, dependent: :destroy
    has_many :stickers, through: :post_stickers

    validates :story, presence: true
    enum :category, {
        "Production Meltdown": "Production Meltdown",
        "Git Tangle": "Git Tangle",
        "Tutorial Hell": "Tutorial hell",
        "Meeting Mishap": "meeting mishap",
        "Burnout": "burnout",
        "Client Chaos": "client chaos",
        "Startup Burial": "startup burial",
        "Imposter Syndrome": "imposter syndrome",
        "General Mess": "General mess"
    }, default: "General Mess"
end
