class UserStory < ApplicationRecord
  validates :title, presence: true, uniqueness: { scope: %i[room_id] }
  belongs_to :room, dependent: nil, inverse_of: :user_stories

  has_many :estimations, dependent: :destroy
  has_many :estimation_values, through: :estimations, dependent: nil
  has_many :users, through: :estimations, dependent: nil
end
