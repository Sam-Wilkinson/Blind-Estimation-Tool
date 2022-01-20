class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
    return if @room.include?(current_user)

    flash[:alert] = 'You need to join the room to see the room!'
    redirect_to rooms_path
  end

  def join
    @room = Room.find(params[:id])
    if @room.include?(current_user)
      flash[:warning] = t('views.rooms.actions.join_room.middling')
      render 'show'
      return
    end

    @room.users << current_user
    flash[:notice] = t('views.rooms.actions.join_room.success')
    render 'show'
  end
end
