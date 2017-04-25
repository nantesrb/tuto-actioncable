class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    # broadcast vers le channel identifié
    ActionCable.server.broadcast "rooms_#{message.room_id}_channel",
                                 message: render_message(message)
  end

  private

  def render_message(message)
    # rendu HTML du message
    MessagesController.render(
      partial: 'messages/message',
      locals: { message: message }
    )
  end
end
