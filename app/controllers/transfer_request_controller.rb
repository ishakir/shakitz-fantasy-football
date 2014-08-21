# -*- encoding : utf-8 -*-
require 'illegal_state_error'

class TransferRequestController < ApplicationController
  REQUEST_USER_ID_KEY   = :request_user_id
  TARGET_USER_ID_KEY    = :target_user_id
  OFFERED_PLAYER_ID_KEY = :offered_player_id
  TARGET_PLAYER_ID_KEY  = :target_player_id

  ACTION_KEY = :action_type
  ID_KEY     = :id

  def create
    validate_all_parameters([REQUEST_USER_ID_KEY, TARGET_USER_ID_KEY, OFFERED_PLAYER_ID_KEY, TARGET_PLAYER_ID_KEY], params)

    request_user = User.find(params[REQUEST_USER_ID_KEY])
    target_user = User.find(params[TARGET_USER_ID_KEY])

    offered_player = NflPlayer.find(params[OFFERED_PLAYER_ID_KEY])
    target_player = NflPlayer.find(params[TARGET_PLAYER_ID_KEY])

    TransferRequest.create!(
      request_user: request_user,
      target_user: target_user,
      offered_player: offered_player,
      target_player: target_player
    )
  end

  def status
  end

  def resolve
    validate_all_parameters([ACTION_KEY, ID_KEY], params)

    action_type = params[ACTION_KEY]
    fail ArgumentError, "action should be accept or reject" unless action_type == "accept" || action_type == "reject"

    transfer_request = TransferRequest.find(params[ID_KEY])
    handle_swap(transfer_request) if action_type == "accept"
    transfer_request.destroy!
  end

  def handle_swap(transfer_request)
    # Find instance of game_week_team and match_player for user one
    game_week_team_one = transfer_request.request_user.team_for_current_game_week
    match_player_one = transfer_request.offered_player.player_for_current_game_week

    # Find instance of game_week_team and match_player for user two
    game_week_team_two = transfer_request.target_user.team_for_current_game_week
    match_player_two = transfer_request.target_player.player_for_current_game_week

    # Get the game_week_team_players
    game_week_team_player_one = find_game_week_team_player(game_week_team_one, match_player_one)
    game_week_team_player_two = find_game_week_team_player(game_week_team_two, match_player_two)

    # Swap the game week teams
    game_week_team_player_one.game_week_team = game_week_team_two
    game_week_team_player_two.game_week_team = game_week_team_one

    # Save
    game_week_team_player_one.save!
    game_week_team_player_two.save!
  end

  def find_game_week_team_player(game_week_team, match_player)
    list = GameWeekTeamPlayer.where(game_week_team: game_week_team, match_player: match_player)
    fail IllegalStateError, "zero game_week_team_players found with game_week_team_id #{game_week_team.id} and match_player_id #{match_player.id}" if list.empty?
    fail IllegalStateError, "#{list.size} game_week_team_players found with game_week_team_id #{game_week_team.id} and match_player_id #{match_player.id}" if list.size > 1
    list.first
  end
end
