class EstimationValue < ApplicationRecord
  validates :value, uniqueness: true, presence: true
  validates :placement, uniqueness: true, presence: true
end
