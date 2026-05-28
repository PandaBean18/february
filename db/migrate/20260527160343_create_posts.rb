class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :category
      t.string :kind
      t.text :story

      t.timestamps
    end
  end
end
