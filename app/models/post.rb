class Post < ApplicationRecord
    belongs_to :user
    has_many :reaction, dependent: :destroy

    validates :story, presence: true
  # enum :category, {
  #     production_meltdown: "Production Meltdown",
  #     git_tangle: "Git Tangle",
  #     tutorial_hell: "Tutorial hell",
  #     meeting_mishap: "meeting mishap",
  #     burnout: "burnout",
  #     client_chaos: "client chaos",
  #     startup_burial: "startup burial",
  #     imposter_syndrome: "imposter syndrome",
  #     general_mess: "General mess"
  # }, default: :general_mess
end
