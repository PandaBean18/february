class AddProfilePictureToUsers < ActiveRecord::Migration[8.1]
    def change
        add_reference :users, :profile_picture, null: true, foreign_key: { to_table: :media }, type: :uuid
    end
end
