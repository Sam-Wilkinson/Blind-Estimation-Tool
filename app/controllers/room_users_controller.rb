class RoomUsersController < ApplicationController
  before_action :set_requested_room

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
    user = User.find(params[:user_id])
    msg = if @room.admin == current_user
            @room.remove_user(user)
            { notice: t('views.rooms.actions.kick_user.success') }
          else
            { alert: t('views.rooms.actions.kick_user.denied') }
          end
    redirect_to room_path(@room), msg
  end

  def join
    if @room.include?(current_user)
      flash[:warning] = t('views.rooms.actions.join_room.middling')
    else
      @room.add_user(current_user)
      flash[:notice] = t('views.rooms.actions.join_room.success')
    end
    render 'rooms/show'
  end

  private

  def set_requested_room
    @room = Room.find(params[:id])
  end
end
