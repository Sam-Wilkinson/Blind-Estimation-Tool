class UserStoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin_status, except: %i[show destroy]
  before_action :set_requested_user_story_value, except: %i[create]

  def create
    user_story = UserStory.new(user_story_params)
    room = Room.find(params[:room_id])
    user_story.room = room
    msg = if user_story.save
            { notice: t('views.user_stories.actions.create.success') }
          else
            { warning: t('views.user_stories.actions.create.failure') }
          end
    redirect_to room_path(room), msg
  end

  def show
    @estimation_values = EstimationValue.order(placement: :asc)
    @estimation = current_user.estimations.find_or_initialize_by(user_story: @user_story)

    if @user_story.room.include?(current_user)
      render 'show'
    else
      redirect_to rooms_path, alert: t('views.user_stories.access.denied')
    end
  end

  def update
    if @user_story.update(user_story_params)
      redirect_to user_story_path, notice: t('views.user_stories.flash_messages.update.success')
    else
      redirect_to user_story_path, alert: t('views.user_storiesflash_messages.update.failure')
    end
  end

  def destroy
    room = @user_story.room
    redirect_to room, alert: t('views.user_stories.access.denied') unless current_user == room.admin
    @user_story.destroy
    redirect_to room, notice: t('views.user_stories.flash_messages.delete.success')
  end

  private

  def user_story_params
    params.require(:user_story).permit(%i[title description])
  end

  def authenticate_admin_status
    room = Room.find(params[:room_id])
    redirect_to rooms_path(room), alert: t('views.user_stories.access.denied') unless current_user == room.admin
  end

  def set_requested_user_story_value
    @user_story = UserStory.find(params[:id])
  end
end
