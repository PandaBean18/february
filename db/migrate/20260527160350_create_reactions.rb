class CreateReactions < ActiveRecord::Migration[8.1]
  def change
    create_table :reactions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :post, null: false, foreign_key: true, type: :uuid
      t.string :reaction_type

      t.timestamps
    end
  end
end
