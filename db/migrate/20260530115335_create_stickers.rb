class CreateStickers < ActiveRecord::Migration[8.1]
  def change
    create_table :stickers, id: :uuid do |t|
      t.string :name, null: false
      t.references :medium, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
