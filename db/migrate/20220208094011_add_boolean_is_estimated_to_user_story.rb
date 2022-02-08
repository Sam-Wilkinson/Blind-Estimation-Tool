class AddBooleanIsEstimatedToUserStory < ActiveRecord::Migration[6.1]
  def change
    add_column :user_stories, :is_estimated, :boolean, default: false
  end
end
