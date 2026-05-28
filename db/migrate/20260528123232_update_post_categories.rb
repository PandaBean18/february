class UpdatePostCategories < ActiveRecord::Migration[8.1]
    def change
        remove_column :posts, :kind, :string

        create_enum :post_category, [
            "Production Meltdown",
            "Git Tangle",
            "Tutorial hell",
            "meeting mishap",
            "burnout",
            "client chaos",
            "startup burial",
            "imposter syndrome",
            "General mess"
        ]

        change_column :posts, :category, :enum, enum_type: :post_category, default: "General mess", null: false, using: "category::post_category"
    end
end
