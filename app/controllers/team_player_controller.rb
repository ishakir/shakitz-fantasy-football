# -*- encoding : utf-8 -*-
class TeamPlayerController < ApplicationController
  USER_ID_KEY = :user_id
  PLAYER_ID_KEY = :player_id
  MAX_PLAYING_SIZE = 10
  MAX_BENCH_SIZE = 8
  DEFAULT_GAMEWEEK = 1

  def add_player
    validate_all_parameters([USER_ID_KEY, PLAYER_ID_KEY], params)

    user_id = params[USER_ID_KEY]
    nfl_player = NflPlayer.find(params[PLAYER_ID_KEY]).player_for_game_week(DEFAULT_GAMEWEEK)
    user_team = User.find(user_id).team_for_game_week(DEFAULT_GAMEWEEK)

    validate_player_is_not_present_in_other_team(nfl_player)

    fail ActiveRecord::RecordInvalid if user_team.match_players.size >= MAX_PLAYING_SIZE + MAX_BENCH_SIZE
    is_playing = user_team.match_players.size >= MAX_PLAYING_SIZE

    GameWeekTeamPlayer.create!(game_week_team: user_team, match_player: nfl_player, playing: is_playing)

    render json: { response: "OK", status: 200 }
  end

  def validate_player_is_not_present_in_other_team(player)
    fail ArgumentError, "This player is already in a team" unless GameWeekTeamPlayer.where(match_player: player).nil?
  end
end
