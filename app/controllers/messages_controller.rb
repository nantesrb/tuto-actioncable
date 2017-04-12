class MessagesController < ApplicationController
  before_action :set_room, only: [:create]

  def create
    @message      = Message.new(message_params)
    @message.room = @room
    @message.user = current_user
    @message.save
    redirect_to room_path(@room)
  end

  private
    def set_room
      @room = Room.find(params[:room_id])
    end

    def message_params
      params.require(:message).permit(:content)
    end
end
