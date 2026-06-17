class CreateRefreshTokens < ActiveRecord::Migration[8.1]
    def change
        create_table :refresh_tokens, id: :uuid do |t|
            t.string :token, null: false
            t.datetime :expires_at, null: false
            t.references :user, null: false, foreign_key: true, type: :uuid

            t.timestamps
        end
        add_index :refresh_tokens, :token, unique: true
    end
end
