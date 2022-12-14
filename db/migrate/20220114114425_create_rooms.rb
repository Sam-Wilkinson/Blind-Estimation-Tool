class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.index :name, unique: true
      t.timestamps
    end
  end
end
