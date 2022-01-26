class RoomUsersController < ApplicationController
  def kick
    room = Room.find(params[:id])
    user = User.find(params[:user_id])
    msg = if room.admin == current_user
            room.remove_user(user)
            { notice: t('views.rooms.actions.kick_user.success') }
          else
            { alert: t('views.rooms.actions.kick_user.denied') }
          end
    redirect_to room_path(room), msg
  end
end
