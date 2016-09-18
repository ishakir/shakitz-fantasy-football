# -*- encoding : utf-8 -*-
class TeamPlayerController < ApplicationController
  USER_ID_KEY = :user_id
  PLAYER_ID_KEY = :player_id

  MAX_PLAYING_SIZE = 10
  MAX_BENCH_SIZE = 8
  DEFAULT_GAMEWEEK = 1

  def add_player
    validate_all_parameters([USER_ID_KEY, PLAYER_ID_KEY], params)

    match_player = first_match_player(params[PLAYER_ID_KEY])
    user_team = first_game_week_team(params[USER_ID_KEY])

    validate_can_add_player(user_team, match_player)

    GameWeekTeamPlayer.create!(
      game_week_team: user_team,
      match_player: match_player,
      playing: all_playing_positions_filled?(user_team)
    )

    render json: ok_response
  end

  private

  def all_playing_positions_filled?(game_week_team)
    game_week_team.match_players.size < MAX_PLAYING_SIZE
  end

  def validate_can_add_player(team, player)
    validate_team_is_not_already_full(team)
    validate_player_is_not_present_in_other_team(player)
  end

  def validate_team_is_not_already_full(team)
    raise ActiveRecord::RecordInvalid if team.match_players.size >= MAX_PLAYING_SIZE + MAX_BENCH_SIZE
  end

  def validate_player_is_not_present_in_other_team(player)
    raise ArgumentError, 'This player is already in a team' unless GameWeekTeamPlayer.where(match_player: player).empty?
  end

  def first_match_player(nfl_player_id)
    NflPlayer.find(nfl_player_id).player_for_game_week(DEFAULT_GAMEWEEK)
  end

  def first_game_week_team(user_id)
    User.find(user_id).team_for_game_week(DEFAULT_GAMEWEEK)
  end
end
