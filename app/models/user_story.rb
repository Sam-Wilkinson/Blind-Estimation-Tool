class UserStory < ApplicationRecord
  validates :title, presence: true, uniqueness: { scope: %i[room_id] }
  belongs_to :room, dependent: nil, inverse_of: :user_stories

  has_many :estimations, dependent: :destroy
  has_many :estimation_values, through: :estimations, dependent: nil
  has_many :users, through: :estimations, dependent: nil
  belongs_to :estimation_value, optional: true

  def all_users_have_estimated?
    users_in_room = room.users.to_set
    users_in_room.add(room.admin)
    users_with_estimation = estimations.map(&:user).to_set
    users_in_room.difference(users_with_estimation).empty?
  end

  def update_consensus
    return unless all_users_have_estimated?

    minimum_estimation_placement = EstimationValue.joins(:estimations).where('estimations.user_story' => self).minimum(:placement)
    maximum_estimation_placement = EstimationValue.joins(:estimations).where('estimations.user_story' => self).maximum(:placement)

    if maximum_estimation_placement - minimum_estimation_placement <= 1
      update(estimation_value: EstimationValue.find_by(placement: maximum_estimation_placement))
    else
      update(estimation_value: nil)
    end
  end

  def delete_estimations
    estimations.delete_all
  end
end
