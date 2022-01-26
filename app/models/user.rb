class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, 'valid_email_2/email': true

  has_many :room_users, dependent: :destroy
  has_many :rooms, through: :room_users, dependent: :destroy
  has_many :owned_rooms, class_name: 'Room', dependent: :destroy, inverse_of: :admin
end
