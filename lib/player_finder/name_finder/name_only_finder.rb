# -*- encoding : utf-8 -*-
module PlayerFinder
  module NameFinder
    class NameOnlyFinder
      def initialize(id_hash)
        @name = id_hash[PlayerFinder::NAME_KEY]
      end

      def add_no_player_found_message(message)
        message.add_message(12, "No player was found with name '#{@name}'")
      end

      def add_multiple_players_found_message(message)
        message.add_message(21, multiple_players_message)
      end

      def add_inconsistancy_messages(_message)
        # Nothing doing here
      end

      def player
        players = NflPlayer.where(name: @name)
        return :none     if players.empty?
        return :too_many if players.size > 1
        players.shift
      end

      private

      def multiple_players_message
        "Multiple players were found with name 'name', please specify team," \
        ' type or both to uniquely identify the player.'\
        " Alternatively provide the player's id."
      end
    end
  end
end
