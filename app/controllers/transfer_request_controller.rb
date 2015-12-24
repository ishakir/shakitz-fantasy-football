# -*- encoding : utf-8 -*-
require 'illegal_state_error'

class TransferRequestController < ApplicationController
  OFFERING_USER_ID_KEY = :offering_user_id
  TARGET_USER_ID_KEY    = :target_user_id
  OFFERED_PLAYER_IDS_KEY = :offered_player_ids
  TARGET_PLAYER_IDS_KEY  = :target_player_ids
  TRADE_BACK_GAME_WEEK_KEY = :trade_back_game_week
  TRANSFER_REQUEST_ID_KEY = :transfer_request

  ACTION_KEY = :action_type
  ID_KEY     = :id

  ACTION_ACCEPT = 'accept'
  ACTION_REJECT = 'reject'
  ACTION_CANCEL = 'cancel'

  ALL_ACTIONS = [ACTION_ACCEPT, ACTION_CANCEL, ACTION_REJECT]

  def create
    validate_all_create_parameters(params)

    transfer_request = params[TRANSFER_REQUEST_ID_KEY]
    create_transfer_request(transfer_request)

    redirect_to transfer_request_path
  end

  def status
    @has_actions = does_user_have_actions_to_complete(TransferRequest.where(status: TransferRequest::STATUS_PENDING))
    @pending_transfers = TransferRequest.where(status: TransferRequest::STATUS_PENDING)
    @completed_transfers = TransferRequest.where.not(status: TransferRequest::STATUS_PENDING)
    @last_comment = get_timestamp_of_last_comment
  end

  def resolve
    validate_all_parameters([ACTION_KEY, ID_KEY], params[TRANSFER_REQUEST_ID_KEY])

    action_type = params[TRANSFER_REQUEST_ID_KEY][ACTION_KEY]
    fail ArgumentError, 'Action should be accept, cancel or reject' unless ALL_ACTIONS.include?(action_type)

    find_and_resolve_transfer_request(params[TRANSFER_REQUEST_ID_KEY][ID_KEY], action_type)

    redirect_to transfer_request_path
  end

  private

  def create_transfer_request(transfer_request_params)
    offering_user = User.find(transfer_request_params[OFFERING_USER_ID_KEY])
    target_user = User.find(transfer_request_params[TARGET_USER_ID_KEY])

    trade_back_game_week = params[TRADE_BACK_GAME_WEEK_KEY] ? params[TRADE_BACK_GAME_WEEK_KEY] : nil

    request = TransferRequest.create!(
      offering_user: offering_user,
      target_user: target_user,
      trade_back_game_week: trade_back_game_week
    )

    transfer_request_params[OFFERED_PLAYER_IDS_KEY].each do |id|
      offered_player = NflPlayer.find(id)
      request.transfer_request_players.create!(nfl_player: offered_player, offered: true)
    end

    transfer_request_params[TARGET_PLAYER_IDS_KEY].each do |id|
      target_player = NflPlayer.find(id)
      request.transfer_request_players.create!(nfl_player: target_player, offered: false)
    end

    # Save ensures we re-validate
    request.save!
  end

  def validate_all_create_parameters(params)
    validate_all_parameters([TRANSFER_REQUEST_ID_KEY], params)
    validate_all_parameters(
      [
        OFFERING_USER_ID_KEY,
        TARGET_USER_ID_KEY,
        OFFERED_PLAYER_IDS_KEY,
        TARGET_PLAYER_IDS_KEY
      ],
      params[TRANSFER_REQUEST_ID_KEY]
    )
    offered_player_ids = params[TRANSFER_REQUEST_ID_KEY][OFFERED_PLAYER_IDS_KEY]
    target_player_ids = params[TRANSFER_REQUEST_ID_KEY][TARGET_PLAYER_IDS_KEY]

    if not offered_player_ids.kind_of?(Array) or offered_player_ids.kind_of?(String)
      fail ArgumentError, "Expected offered_player_ids to be an array, instead got #{offered_player_ids}"
    end
    if not target_player_ids.kind_of?(Array) or target_player_ids.kind_of?(String)
      fail ArgumentError, "Expected target_player_ids to be an array, instead got #{target_player_ids}"
    end

    if offered_player_ids.length == 0 && target_player_ids.length == 0
      fail ArgumentError, "No players offered or targeted"
    end
  end

  def find_and_resolve_transfer_request(transfer_request_id, action_type)
    transfer_request = TransferRequest.find(transfer_request_id)

    if action_type == ACTION_ACCEPT
      handle_swap(transfer_request)
      transfer_request.status = TransferRequest::STATUS_ACCEPTED
    end
    transfer_request.status = TransferRequest::STATUS_REJECTED if action_type == ACTION_REJECT
    transfer_request.status = TransferRequest::STATUS_CANCELLED if action_type == ACTION_CANCEL

    transfer_request.save!
  end

  def handle_swap(transfer_request)
    # TODO some validation that all players are still in their given team
    offered_game_week_team = transfer_request.offering_user.team_for_current_unlocked_game_week
    targeted_game_week_team = transfer_request.target_user.team_for_current_unlocked_game_week  
    transfer_request.offered_players.zip(transfer_request.target_players).each do |arr|
      # Get the game_week_team_players
      offered_game_week_team_player = find_game_week_team_player(offered_game_week_team, arr[0])
      targeted_game_week_team_player = find_game_week_team_player(targeted_game_week_team, arr[1])
      
      # Swap the game week teams
      offered_game_week_team_player.game_week_team = targeted_game_week_team
      targeted_game_week_team_player.game_week_team = offered_game_week_team

      # Save
      offered_game_week_team_player.save!
      targeted_game_week_team_player.save!
    end
  end

  def does_user_have_actions_to_complete(pending_transfers)
    pending_transfers.each do |p|
      next unless p['offering_user_id'] == session[:user_id] || p['target_user_id'] == session[:user_id]
      return true
    end
    false
  end

  def find_game_week_team_player(game_week_team, player)
    match_player = player.player_for_current_unlocked_game_week
    GameWeekTeamPlayer.find_unique_with(game_week_team, match_player)
  end
end
