class CreateRoomsUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms_users, id: false do |t|
      t.belongs_to :room, null: false
      t.belongs_to :user, null: false
    end
  end
end
