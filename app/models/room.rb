class Room < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  belongs_to :admin, class_name: 'User', foreign_key: 'user_id', dependent: nil, inverse_of: :owned_rooms
  has_and_belongs_to_many :users

  def include?(user)
    users.include?(user) || admin == user
  end
end
