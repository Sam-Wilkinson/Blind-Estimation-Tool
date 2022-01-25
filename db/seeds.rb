# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def seed_dummy_users_with_rooms(user_amount = 5, room_amount_per_user = 2)
  (user_amount - User.count).times do
    FactoryBot.create(:user_with_rooms, rooms_count: room_amount_per_user)
  end
end

def seed_users_into_rooms(users_per_room = 3)
  return unless User.count > users_per_room

  Room.all.each do |room|
    users = User.where.not(id: room.admin)
    users = users.limit(users_per_room).order('RANDOM()')
    room.users << users
  end
end

def seed_estimation_values(amount = 10)
  amount.times { |i| FactoryBot.create(:estimation_value, placement: i) }
end

FactoryBot.create(:user, username: 'SamWilkinson', email: 'sam.wilkinson@blue-planet.be', password: 'admin1', isAdmin: true)
seed_dummy_users_with_rooms
seed_users_into_rooms
seed_estimation_values
