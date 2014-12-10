# -*- encoding : utf-8 -*-
require 'illegal_state_error'

module PlayerFinder
  class TeamTypeFinder
    def initialize(id_hash)
      @team = id_hash[PlayerFinder::TEAM_KEY]
      @type = id_hash[PlayerFinder::TYPE_KEY]
    end

    def add_no_player_found_message(message)
      message.add_message(
        15,
        "No player was found with team '#{@team}' and type '#{@type}'"
      )
    end

    def add_multiple_players_found_message(message)
      message.add_message(24, multiple_players_message)
    end

    def add_inconsistancy_messages(_message)
      # Nothing doing here
    end

    def player
      teams = NflTeam.where(name: @team)
      types = NflPlayerType.where(position_type: @type)
      fail IllegalStateError unless teams.size == 1 && types.size == 1

      players = NflPlayer.where(
        nfl_team: teams.shift,
        nfl_player_type: types.shift
      )
      return :none     if players.empty?
      return :too_many if players.size > 1
      players.shift
    end

    private

    def multiple_players_message
      "Multiple players were found with team '#{@team}' and type '#{@type}'," \
      ' please specify the name to uniquely identify the player.' \
      " Alternatively provide the player's id."
    end
  end
end
