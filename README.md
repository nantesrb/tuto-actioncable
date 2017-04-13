# Tutoriel ActionCable - Instructions

## A. Installation
1.  Cloner l'application :
    ```shell
    $ git clone git@github.com:nantesrb/tuto-actioncable.git
    $ cd tuto-actioncable
    ```

1.  Se mettre sur la branche `tuto-base`:
    ```shell
    $ git checkout tuto-base
    ```

1.  Déployer la base de donnée:
    ```shell
    $ rails db:migrate db:seed
    ```

1.  Lancer l'application en local
    ```shell
    $ rails server
    ```

Vous voilà avec une application de t'chat de base. Il existe des seeds pour utiliser l'application avec les utilisateurs Alice et Bob :
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
1.  Ajout d'une route pour le `cable`
    ```ruby
    # config/routes.rb
    Rails.application.routes.draw do
    mount ActionCable.server => '/cable'
    [...]
    end
    ```

1.  Ajout de l'url du server ActionCable pour le développement
    ```ruby
    # config/environments/development.rb

    Rails.application.configure do
      [...]
      config.action_cable.url = "ws://localhost:3000/cable"
    end
    ```

## C. Configuration serveur
1.  Identification des utilisateurs connectés avec Devise
    ```ruby
    # app/channels/application_cable/connection.rb
    module ApplicationCable
      class Connection < ActionCable::Connection::Base
        identified_by :current_user

        def connect
          self.current_user = find_verified_user
          logger.add_tags 'ActionCable', current_user.email
        end

        protected

        def find_verified_user # this checks whether a user is authenticated with devise
          if verified_user = env['warden'].user
            verified_user
          else
            reject_unauthorized_connection
          end
        end
      end
    end
    ```

1.  Définition des méthodes utilisées par le `channel` des `rooms`
    ```ruby
    # app/channels/rooms_channel.rb
    class RoomsChannel < ApplicationCable::Channel
      def subscribed
        stream_from "rooms_#{params['room_id']}_channel"
      end

      def unsubscribed
        # Any cleanup needed when channel is unsubscribed
      end

      def send_message(data)
        current_user.messages.create!(
          content: data['message'],
          room_id: data['room_id']
        )
      end
    end
    ```

1.  Création du `job` pour les messages envoyés
    ```ruby
    # app/jobs/message_broadcast_job.rb
    class MessageBroadcastJob < ApplicationJob
      queue_as :default

      def perform(message)
        ActionCable.server.broadcast "rooms_#{message.room.id}_channel",
                                     message: render_message(message)
      end

      private

        def render_message(message)
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
      belongs_to :user
      belongs_to :room

      after_create_commit { MessageBroadcastJob.perform_later(self) }
    end
    ```

## D. Configuration client
TODO

## E. Configuration pour la production (Heroku)
TODO

## Bonus : Identifier le `current_user`
TODO
