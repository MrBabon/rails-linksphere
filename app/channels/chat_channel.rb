class ChatChannel < ApplicationCable::Channel
  def subscribed
    chatroom = Chatroom.find_by(id: params[:id])
    if chatroom && chatroom.participant?(current_user)
      stream_for chatroom
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
