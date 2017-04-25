module ApplicationCable
  class Connection < ActionCable::Connection::Base
<<<<<<< HEAD
=======
    # définit l'accesseur renvoyant l'utilisateur identifié
>>>>>>> tuto-base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
<<<<<<< HEAD
=======
      # préfixe des logs propres à action cable
>>>>>>> tuto-base
      logger.add_tags 'ActionCable', current_user.email
    end

    protected

<<<<<<< HEAD
      def find_verified_user # this checks whether a user is authenticated with devise
        if verified_user = env['warden'].user
          verified_user
        else
          reject_unauthorized_connection
        end
      end
=======
    def find_verified_user
      # authentification via warden (devise)
      if verified_user = env['warden'].user
        verified_user
      else
        reject_unauthorized_connection
      end
    end
>>>>>>> tuto-base
  end
end
