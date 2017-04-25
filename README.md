# Tutoriel ActionCable - Instructions

## A. Installation
1.  Cloner l'application :
    ```shell
    $ git clone -b tuto-base git@github.com:nantesrb/tuto-actioncable.git
    $ cd tuto-actioncable
    ```

1.  Installation des gems :
    ```shell
    $ bundle install
    ```

1.  Déployer la base de données :
    ```shell
    $ rails db:migrate db:seed
    ```

1.  Lancer l'application en local
    ```shell
    $ rails server
    ```

Vous voilà avec une [application de t'chat de base](http://localhost:3000). Il existe des seeds pour utiliser l'application avec les utilisateurs Alice et Bob :
```
Alice:
  email:    alice@example.com
  password: password

Bob:
  email:    bob@example.com
  password: password
```

À cette étape, il est nécessaire de recharger la page pour voir si de nouveaux messages sont arrivés... Pas très pratique ! Mettons en place ActionCable pour fluidifier tout ça...

## B. Configuration de base
1.  Ajout de la route pour Action Cable
    ```ruby
    # config/routes.rb
    Rails.application.routes.draw do
      mount ActionCable.server => '/cable'
      [...]
    end
    ```

1.  Ajout de l'URL du server ActionCable pour le développement
    ```ruby
    # config/environments/development.rb

    Rails.application.configure do
      [...]
      config.action_cable.url = "ws://localhost:3000/cable"
    end
    ```

## C. Configuration du backend
1.  Établissement de la connexion initiale avec le client.

    ```ruby
    # app/channels/application_cable/connection.rb
    module ApplicationCable
      class Connection < ActionCable::Connection::Base
        # définit l'accesseur renvoyant l'utilisateur identifié
        identified_by :current_user

        def connect
          self.current_user = find_verified_user
          # préfixe des logs propres à action cable
          logger.add_tags 'ActionCable', current_user.email
        end

        protected

        def find_verified_user
          # authentification via warden (devise)
          if verified_user = env['warden'].user
            verified_user
          else
            reject_unauthorized_connection
          end
        end
      end
    end
    ```

1.  Génération du channel :
    ```shell
    $ rails g channel rooms
    ```

    Définition du `channel` des `rooms`
    ```ruby
    # app/channels/rooms_channel.rb
    class RoomsChannel < ApplicationCable::Channel
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
      def send_message(data)
        current_user.messages.create!(
          content: data['message'],
          room_id: data['room_id']
        )
      end
    end
    ```

1.  Génération du job :
    ```shell
    $ rails g job message_broadcast
    ```

    Définition du `job` pour les messages envoyés
    ```ruby
    # app/jobs/message_broadcast_job.rb
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
    ```

1.  Appel du `job` à la creation d'un message
    ```ruby
    # app/models/message.rb
    class Message < ApplicationRecord
      [...]

      after_create_commit :broadcast

      private

      def broadcast
        MessageBroadcastJob.perform_later(self)
      end
    end
    ```

## D. Configuration client
1. Ajout du meta tag :
    ```erb
    <!-- app/views/layouts/application.html.erb -->
    [...]
    <%= csrf_meta_tags %>
    <%= action_cable_meta_tag %>
    [...]
    ```

1.  Ajout de `data` identifiables par le javascript dans la vue du `message`
    ```erb
    <!-- app/views/messages/_message.html.erb -->
    <div class="message" data-user-id="<%= message.user_id %>">
      <p>
        <%= message.content %>
      </p>
      <div class="message-info">
        <strong><%= message.user.name %></strong>
        <%= l(message.created_at, format: "%H:%M - %d/%m") %>
      </div>
    </div>
    ```

1.  Ajout de `data` identifiables par le javascript dans la vue de la `room` et ajout du `remote` pour le formulaire (pour ne pas appeler une nouvelle route)
    ```erb
    <!-- app/views/rooms/show.html.erb -->
    <h1><%= @room.name.capitalize %></h1>

    <div id="messages" class="container" data-room-id="<%= @room.id %>">
      <%= "No message in this room" unless @room.messages.exists? %>
      <%= render @room.messages %>
    </div>

    <div class="container">
      <hr>
      <%= simple_form_for [@room, @new_message], remote: true do |f| %>
        <%= f.input :content, label: 'message', placeholder: "say something nice" %>
        <%= f.submit "Send", class: "btn btn-success" %>
      <% end %>
    </div>
    ```

1.  Gestion en javascript de l'envoi et de la réception des messages
    ```coffeescript
    # app/assets/javascripts/channels/rooms.coffee
    App.rooms = App.cable.subscriptions.create {
        channel: "RoomsChannel",
        room_id: $('#messages').data('room-id')
      },

      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        # Called when there's incoming data on the websocket for this channel
        $('#messages').append(data.message)

      send_message: (message, room_id) ->
        @perform 'send_message', message: message, room_id: room_id

      $('#new_message').submit (e) ->
        $this = $(this)
        textarea = $this.find('#message_content')
        if $.trim(textarea.val()).length > 1
          App.rooms.send_message textarea.val(), $('#messages').data('room-id')
          textarea.val('')
        e.preventDefault()
        false
    ```

## E. Pour aller plus loin
- Identifier l'auteur d'un message pour appliquer un style CSS différent aux messages envoyés (message à droite par exemple)
- Afficher les utilisateurs connectés dans une `room`
