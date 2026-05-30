class FixMediaAndStickersSchema < ActiveRecord::Migration[8.1]
    def change
        add_index :stickers, :name, unique: true
        remove_column :media, :cloudinary_url, :string
        add_column :media, :cloudinary_public_id, :string, null: false
    end
end
