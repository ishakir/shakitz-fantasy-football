# -*- encoding : utf-8 -*-
require 'illegal_state_error'

module PlayerFinder
  module NameFinder
    class NameTeamFinder
      def initialize(id_hash)
        @name = id_hash[PlayerFinder::NAME_KEY]
        @team = id_hash[PlayerFinder::TEAM_KEY]
      end

      def add_no_player_found_message(message)
        message.add_message(14, "No player was found with name '#{@name}' and team '#{@team}'")
      end

      def add_multiple_players_found_message(message)
        message.add_message(23, multiple_players_message)
      end

      def add_inconsistancy_messages(_message)
        # Nothing doing here
      end

      def player
        teams = NflTeam.where(name: @team)
        raise IllegalStateError unless teams.size == 1

        players = NflPlayer.where(name: @name, nfl_team: teams[0])
        return :none     if players.empty?
        return :too_many if players.size > 1
        players[0]
      end

      private

      def multiple_players_message
        "Multiple players were found with name '#{@name}' and team '#{@team}'," \
        ' please specify the type to uniquely identify the player.' \
        " Alternatively provide the player's id."
      end
    end
  end
end
