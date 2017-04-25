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
