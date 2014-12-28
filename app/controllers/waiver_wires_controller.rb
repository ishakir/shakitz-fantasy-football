class WaiverWiresController < ApplicationController
  USER_KEY = :user
  PLAYER_IN_KEY = :player_in
  PLAYER_OUT_KEY = :player_out
  GAME_WEEK_KEY = :game_week
  PRIORITY_KEY = :incoming_priority

  def add
    params['request'].each do |p|
      validate_waiver_wire_params(p)
    end
  end

  def validate_waiver_wire_params(params)
    validate_all_parameters([USER_KEY, PLAYER_IN_KEY, PLAYER_OUT_KEY, GAME_WEEK_KEY, PRIORITY_KEY], params)
    validate_user(params[USER_KEY])
    validate_players(params[PLAYER_IN_KEY], params[PLAYER_OUT_KEY])
    validate_gameweek(params[GAME_WEEK_KEY])
  end

  def validate_user(user)
    fail ArgumentError, 'User does not exist' unless User.find(user)
  end

  def validate_players(incoming_player, outgoing_player)
    fail ArgumentError, 'Player ids cannot be identical' unless incoming_player != outgoing_player
    fail ArgumentError, 'Incoming player does not exist' unless NflPlayer.find(incoming_player)
    fail ArgumentError, 'Outgoing player does not exist' unless NflPlayer.find(outgoing_player)
  end

  def validate_gameweek(game_week)
    fail ArgumentError, 'Gameweek needs to be active gameweek' unless game_week.to_i == WithGameWeek.current_game_week
  end
end
