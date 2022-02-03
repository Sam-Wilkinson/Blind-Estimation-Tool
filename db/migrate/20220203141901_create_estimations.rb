class CreateEstimations < ActiveRecord::Migration[6.1]
  def change
    create_table :estimations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :estimation_value, null: false, foreign_key: true
      t.references :user_story, null: false, foreign_key: true

      t.index [:user_id, :user_story_id], unique: true
      t.timestamps
    end

  end
end
