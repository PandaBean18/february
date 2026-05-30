class CreatePostStickers < ActiveRecord::Migration[8.1]
    def change
        create_table :post_stickers, id: :uuid do |t|
            t.references :post, null: false, foreign_key: true, type: :uuid
            t.references :sticker, null: false, foreign_key: true, type: :uuid

            t.timestamps
        end
    end
end
