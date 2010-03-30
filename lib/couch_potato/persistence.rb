module CouchPotato
  module Persistence

    def save
      CouchPotato.database.save self
    end

  end
end
