class Estimation < ApplicationRecord
  belongs_to :user
  belongs_to :estimation_value
  belongs_to :user_story

  validates :user_story, uniqueness: { scope: :user_id }
end
