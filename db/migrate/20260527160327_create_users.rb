class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :username

      t.timestamps
    end
  end
end
