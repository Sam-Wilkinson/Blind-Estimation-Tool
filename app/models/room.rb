class Room < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  belongs_to :admin, class_name: 'User', foreign_key: 'user_id', dependent: nil, inverse_of: :owned_rooms
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users, dependent: nil

  def include?(user)
    users.include?(user) || admin == user
  end

  def remove_user(user)
    users.destroy(user)
  end
end
