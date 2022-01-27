class RoomUsersController < ApplicationController
  def leave
    if @room.users.exclude?(current_user)
      msg = { alert: t('views.rooms.actions.leave_room.failure') }
    else
      @room.remove_user(current_user)
      msg = { notice: t('views.rooms.actions.leave_room.success') }
    end
    redirect_to rooms_path, msg
  end

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
