# -*- encoding : utf-8 -*-
require 'illegal_state_error'

class TransferRequestController < ApplicationController
  REQUEST_USER_ID_KEY   = :request_user_id
  TARGET_USER_ID_KEY    = :target_user_id
  OFFERED_PLAYER_ID_KEY = :offered_player_id
  TARGET_PLAYER_ID_KEY  = :target_player_id
  TRANSFER_REQUEST_ID_KEY = :transfer_request

  ACTION_KEY = :action_type
  ID_KEY     = :id

  STATUS_ACCEPTED = "accepted"
  STATUS_REJECTED = "rejected"
  STATUS_PENDING = "pending"

  def create
    validate_all_parameters([TRANSFER_REQUEST_ID_KEY], params)
    validate_all_parameters([REQUEST_USER_ID_KEY, TARGET_USER_ID_KEY, OFFERED_PLAYER_ID_KEY, TARGET_PLAYER_ID_KEY], params[TRANSFER_REQUEST_ID_KEY])

    request_user = User.find(params[TRANSFER_REQUEST_ID_KEY][REQUEST_USER_ID_KEY])
    target_user = User.find(params[TRANSFER_REQUEST_ID_KEY][TARGET_USER_ID_KEY])

    offered_player = NflPlayer.find(params[TRANSFER_REQUEST_ID_KEY][OFFERED_PLAYER_ID_KEY])
    target_player = NflPlayer.find(params[TRANSFER_REQUEST_ID_KEY][TARGET_PLAYER_ID_KEY])

    TransferRequest.create!(
      request_user: request_user,
      target_user: target_user,
      offered_player: offered_player,
      target_player: target_player
    )
  end

  def status
    @has_actions = does_user_have_actions_to_complete(TransferRequest.where(status: STATUS_PENDING))
    @pending_transfers = TransferRequest.where(status: STATUS_PENDING)
    @completed_transfers = TransferRequest.where.not(status: STATUS_PENDING)
  end

  def resolve
    validate_all_parameters([ACTION_KEY, ID_KEY], params[TRANSFER_REQUEST_ID_KEY])

    action_type = params[TRANSFER_REQUEST_ID_KEY][ACTION_KEY]
    fail ArgumentError, "action should be accept, cancel or reject" unless action_type == "accept" ||
      action_type == "reject" || action_type == "cancel"

    transfer_request = TransferRequest.find(params[TRANSFER_REQUEST_ID_KEY][ID_KEY])
    handle_swap(transfer_request) if action_type == "accept"
    transfer_request.update!(status: STATUS_REJECTED) if action_type == "reject"
    transfer_request.destroy! if action_type == "cancel"

    redirect_to transfer_request_path
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

    # Change status
    transfer_request.update!(status: STATUS_ACCEPTED)
  end

  def does_user_have_actions_to_complete(pending_transfers)
    result = false
    pending_transfers.each do |p|
      next unless p['request_user_id'] == session[:user_id] || p['target_user_id'] == session[:user_id]
      result = true
    end
    result
  end

  def find_game_week_team_player(game_week_team, match_player)
    list = GameWeekTeamPlayer.where(game_week_team: game_week_team, match_player: match_player)
    fail IllegalStateError, "zero game_week_team_players found with game_week_team_id #{game_week_team.id} and match_player_id #{match_player.id}" if list.empty?
    fail IllegalStateError, "#{list.size} game_week_team_players found with game_week_team_id #{game_week_team.id} and match_player_id #{match_player.id}" if list.size > 1
    list.first
  end
end
