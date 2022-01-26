class UserStory < ApplicationRecord
  validates :title, presence: true, uniqueness: { scope: %i[room_id] }
  belongs_to :room, dependent: nil, inverse_of: :user_stories
end
