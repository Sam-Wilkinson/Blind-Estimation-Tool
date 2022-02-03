class EstimationValue < ApplicationRecord
  validates :value, uniqueness: true, presence: true
  validates :placement, uniqueness: true, presence: true

  has_many :estimations, dependent: :destroy
  has_many :users, through: :estimations, dependent: nil
  has_many :user_stories, through: :estimations, dependent: nil
end
