class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_requested_room_value, except: %i[index create]

  def index
    @rooms = Room.all
  end

  def show
    return if @room.include?(current_user)

    flash[:alert] = 'You need to join the room to see the room!'
    redirect_to rooms_path
  end

  def create
    room = Room.new(room_params)
    room.admin = current_user
    if room.save
      redirect_to room_path(room), notice: t('views.rooms.actions.create_room.success')
    else
      redirect_to rooms_path, alert: t('views.rooms.actions.create_room.failure')
    end
  end

  def update
    if @room.admin == current_user
      if @room.update(room_params)
        redirect_to room_path(@room), notice: t('views.rooms.actions.update_room.success')
      else
        redirect_to room_path(@room), alert: t('views.rooms.actions.update_room.failure')
      end
    elsif @room.users.include?(current_user)
      redirect_to room_path(@room), warning: t('views.rooms.actions.update_room.denied')
    else
      redirect_to rooms_path, warning: t('views.rooms.actions.update_room.denied')
    end
  end

  def destroy
    if @room.admin == current_user
      @room.destroy
      redirect_to rooms_path, notice: t('views.rooms.actions.delete_room.success')
    elsif @room.users.include?(current_user)
      redirect_to room_path(@room), alert: t('views.rooms.actions.delete_room.failure')
    else
      redirect_to rooms_path, alert: t('views.rooms.actions.delete_room.failure')
    end
  end

  def join
    if @room.include?(current_user)
      flash[:warning] = t('views.rooms.actions.join_room.middling')
      render 'show'
      return
    end

    @room.users << current_user
    flash[:notice] = t('views.rooms.actions.join_room.success')
    render 'show'
  end

  def leave
    if @room.users.exclude?(current_user)
      redirect_to rooms_path, alert: t('views.rooms.actions.leave_room.failure')
    else
      @room.users.delete(current_user)
      redirect_to rooms_path, notice: t('views.rooms.actions.leave_room.success')
    end
  end

  private

  def set_requested_room_value
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(%i[name])
  end
end
