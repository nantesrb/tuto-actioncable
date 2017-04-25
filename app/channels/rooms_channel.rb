class RoomsChannel < ApplicationCable::Channel
<<<<<<< HEAD
  def subscribed
    stream_from "rooms_#{params['room_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

=======
  # surcharge
  def subscribed
    # permet de gérer l'inscription du client au channel identifié
    stream_from "rooms_#{params['room_id']}_channel"
  end

  # surcharge
  def unsubscribed
    # gestion de la désinscription du channel
    # (notification, nettoyage de données...)
  end

  # definition de l'"action" send_message
>>>>>>> tuto-base
  def send_message(data)
    current_user.messages.create!(
      content: data['message'],
      room_id: data['room_id']
    )
  end
end
