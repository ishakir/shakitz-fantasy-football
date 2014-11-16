# -*- encoding : utf-8 -*-
module PlayerFinder
  class IdFinder
    def initialize(id_hash)
      @id   = id_hash[PlayerFinder::ID_KEY]
      @name = id_hash[PlayerFinder::NAME_KEY] if id_hash.key?(PlayerFinder::NAME_KEY)
      @team = id_hash[PlayerFinder::TEAM_KEY] if id_hash.key?(PlayerFinder::TEAM_KEY)
      @type = id_hash[PlayerFinder::TYPE_KEY] if id_hash.key?(PlayerFinder::TYPE_KEY)
    end

    def add_no_player_found_message(message)
      message.add_message(11, "No player was found with id '#{@id}'")
    end

    def add_inconsistancy_messages(message)
      check_name(message) unless @name.nil?
      check_team(message) unless @team.nil?
      check_type(message) unless @type.nil?
    end

    def player
      return @player unless @player.nil?
      players = NflPlayer.where(nfl_id: @id)
      return :none if players.empty?
      @player = players.first
    end

    private

    def check_name(message)
      actual_name = @player.name
      return if actual_name == @name
      message.add_message(
        51,
        "Player with id '#{@id}' has inconsistent name, '#{@name}' was specified in the request, " \
        "but '#{actual_name}' was found in the system. Stats have been updated in the system, " \
        'but name has not.'
      )
    end

    def check_team(message)
      actual_team = @player.nfl_team.name
      return if actual_team == @team
      message.add_message(
        53,
        "Player with id '#{@id}' has inconsistent team, '#{@team}' was specified in the request, " \
        "but '#{actual_team}' was found in the system. Stats have been updated in the system, " \
        'but team has not.'
      )
    end

    def check_type(message)
      actual_type = @player.nfl_player_type.position_type
      return if actual_type == @type
      message.add_message(
        52,
        "Player with id '#{@id}' has inconsistent type, '#{@type}' was specified in the request, " \
        "but '#{actual_type}' was found in the system. Stats have been updated in the system, " \
        'but type has not.'
      )
    end
  end
end
