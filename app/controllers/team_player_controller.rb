# -*- encoding : utf-8 -*-
class TeamPlayerController < ApplicationController
  USER_ID_KEY = :user_id
  PLAYER_ID_KEY = :player_id
  GAME_WEEK_KEY = :game_week

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
      playing:  all_playing_positions_filled?(user_team)
    )

    render json: ok_response
  end

  def progress_game_week
    validate_all_parameters([GAME_WEEK_KEY], params)

    previous_game_week_number = params[GAME_WEEK_KEY]

    User.all.each do |user|
      progress_game_week_team(user, previous_game_week_number)
    end
  end

  def progress_game_week_team(user, previous_game_week_number)
    # Get the last and next game week teams
    previous_game_week_team = user.team_for_game_week(previous_game_week_number)
    next_game_week_team = user.team_for_game_week(previous_game_week_number.to_i + 1)

    # For each match player put the player for next week into next weeks team
    previous_game_week_team.match_players.each do |previous_match_player|
      copy_player(previous_match_player, previous_game_week_team, next_game_week_team)
    end
  end

  def copy_player(previous_match_player, previous_game_week_team, next_game_week_team)
    # Get the match player for the next week
    next_match_player = previous_match_player.nfl_player.player_for_game_week(next_game_week_team.game_week.number)

    # Get the previous game week team player
    game_week_team_player = GameWeekTeamPlayer.where(
      match_player: previous_match_player,
      game_week_team: previous_game_week_team
    ).first

    # Create a game week team player for the next week
    GameWeekTeamPlayer.create!(
      match_player: next_match_player,
      game_week_team: next_game_week_team,
      playing: game_week_team_player.playing
    )
  end

  private

  def all_playing_positions_filled?(game_week_team)
    game_week_team.match_players.size < MAX_PLAYING_SIZE
  end

  def first_match_player(nfl_player_id)
    NflPlayer.find(nfl_player_id).player_for_game_week(DEFAULT_GAMEWEEK)
  end

  def first_game_week_team(user_id)
    User.find(user_id).team_for_game_week(DEFAULT_GAMEWEEK)
  end

  def validate_can_add_player(team, player)
    validate_team_is_not_already_full(team)
    validate_player_is_not_present_in_other_team(player)
  end

  def validate_team_is_not_already_full(team)
    fail ActiveRecord::RecordInvalid if team.match_players.size >= MAX_PLAYING_SIZE + MAX_BENCH_SIZE
  end

  def validate_player_is_not_present_in_other_team(player)
    fail ArgumentError, 'This player is already in a team' unless GameWeekTeamPlayer.where(match_player: player).empty?
  end
end
