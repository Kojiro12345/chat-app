class MessagesController < ApplicationController
  def create
    @room = Room.find(RoomMember.find_by(user: current_user, id: params[:room_id]).id)
    @message = @room.messages.new(message_params)
    @message.speaker_id = current_user.id

    if @message.save
      redirect_to room_path(params[:room_id])
    else
      redirect_to room_path(params[:id])
    end
  end
  
  def message_params
    params.require(:message).permit(:body)
  end
end
