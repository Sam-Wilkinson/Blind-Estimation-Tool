class CreateEstimationValues < ActiveRecord::Migration[6.1]
  def change
    create_table :estimation_values do |t|
      t.integer :value
      t.integer :placement
      t.index :value, unique: true
      t.index :placement, unique: true
      t.timestamps
    end
  end
end
