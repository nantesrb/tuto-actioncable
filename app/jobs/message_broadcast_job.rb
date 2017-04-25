class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
<<<<<<< HEAD
=======
    # broadcast vers le channel identifié
>>>>>>> tuto-base
    ActionCable.server.broadcast "rooms_#{message.room_id}_channel",
                                 message: render_message(message)
  end

  private

<<<<<<< HEAD
    def render_message(message)
      MessagesController.render(
        partial: 'messages/message',
        locals: { message: message }
      )
    end
=======
  def render_message(message)
    # rendu HTML du message
    MessagesController.render(
      partial: 'messages/message',
      locals: { message: message }
    )
  end
>>>>>>> tuto-base
end
