class EstimationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user_in_room

  def create
    estimation = Estimation.new(estimation_params)
    msg = if estimation.save
            user_story = UserStory.find(estimation_params[:user_story_id])
            user_story.update_consensus
            { notice: 'Estimation saved successfully' }
          else
            { alert: 'Estimation failed to save' }
          end
    redirect_to UserStory.find(estimation_params[:user_story_id]), msg
  end

  private

  def authenticate_user_in_room
    room = UserStory.find(estimation_params[:user_story_id]).room
    redirect_to rooms_path, alert: t('views.user_stories.access.denied') unless room.include?(current_user)
  end

  def estimation_params
    params.require(:estimation).permit(%i[user_story_id estimation_value_id user_id])
  end
end
