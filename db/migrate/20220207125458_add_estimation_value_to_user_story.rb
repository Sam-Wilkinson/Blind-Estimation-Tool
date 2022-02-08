class AddEstimationValueToUserStory < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_stories, :estimation_value, foreign_key: true
  end
end
