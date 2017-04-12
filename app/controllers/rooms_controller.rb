class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def show
    @room        = Room.includes(:messages).find(params[:id])
    @new_message = Message.new
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to room_path(@room)
    else
      render 'new'
    end
  end

  private

    def room_params
      params.require(:room).permit(:name)
    end
end
