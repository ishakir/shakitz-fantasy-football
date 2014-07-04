module PlayerFinder
  class IdFinder
    def initialize(id_hash)
      @id = id_hash[PlayerFinder::ID_KEY]
    end

    def add_no_player_found_message(message)
      message.add_message(11, "No player was found with id '#{@id}'")
    end

    def player
      NflPlayer.find(@id)
    rescue ActiveRecord::RecordNotFound
      :none
    end
  end
end
