class CreateMedia < ActiveRecord::Migration[8.1]
    def change
        create_table :media, id: :uuid do |t|
            t.string :media_type, null: false
            t.string :cloudinary_url, null: false

            t.timestamps
        end
    end
end
