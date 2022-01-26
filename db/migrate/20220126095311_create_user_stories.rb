class CreateUserStories < ActiveRecord::Migration[6.1]
  def change
    create_table :user_stories do |t|
      t.string :title
      t.text :description
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
    add_index :user_stories, [:title, :room_id], unique: true
  end
end
