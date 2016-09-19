# -*- encoding : utf-8 -*-
require 'illegal_state_error'

module PlayerFinder
  module NameFinder
    class NameTypeFinder
      def initialize(id_hash)
        @name = id_hash[PlayerFinder::NAME_KEY]
        @type = id_hash[PlayerFinder::TYPE_KEY]
      end

      def add_no_player_found_message(message)
        message.add_message(
          13,
          "No player was found with name '#{@name}' and type '#{@type}'"
        )
      end

      def add_multiple_players_found_message(message)
        message.add_message(22, multiple_players_message)
      end

      def add_inconsistancy_messages(_message)
        # Nothing doing here
      end

      def player
        types = NflPlayerType.where(position_type: @type)
        raise IllegalStateError unless types.size == 1

        players = NflPlayer.where(name: @name, nfl_player_type: types[0])
        return :none     if players.empty?
        return :too_many if players.size > 1
        players[0]
      end

      private

      def multiple_players_message
        "Multiple players were found with name '#{@name}' and type" \
        " '#{@type}', please specify the team to uniquely identify the" \
        " player. Alternatively provide the player's id."
      end
    end
  end
end
