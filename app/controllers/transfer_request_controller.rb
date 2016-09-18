# -*- encoding : utf-8 -*-
require 'illegal_state_error'

class TransferRequestController < ApplicationController
  OFFERING_USER_ID_KEY = :offering_user_id
  TARGET_USER_ID_KEY    = :target_user_id
  OFFERED_PLAYER_ID_KEY = :offered_player_id
  TARGET_PLAYER_ID_KEY  = :target_player_id
  TRANSFER_REQUEST_ID_KEY = :transfer_request

  ACTION_KEY = :action_type
  ID_KEY     = :id

  ACTION_ACCEPT = 'accept'.freeze
  ACTION_REJECT = 'reject'.freeze
  ACTION_CANCEL = 'cancel'.freeze

  ALL_ACTIONS = [ACTION_ACCEPT, ACTION_CANCEL, ACTION_REJECT].freeze

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
    @last_comment = timestamp_of_last_comment
  end

  def resolve
    validate_all_parameters([ACTION_KEY, ID_KEY], params[TRANSFER_REQUEST_ID_KEY])

    action_type = params[TRANSFER_REQUEST_ID_KEY][ACTION_KEY]
    raise ArgumentError, 'Action should be accept, cancel or reject' unless ALL_ACTIONS.include?(action_type)

    find_and_resolve_transfer_request(params[TRANSFER_REQUEST_ID_KEY][ID_KEY], action_type)

    redirect_to transfer_request_path
  end

  private

  def create_transfer_request(transfer_request_params)
    TransferRequest.create!(
      offering_user: User.find(transfer_request_params[OFFERING_USER_ID_KEY]),
      target_user: User.find(transfer_request_params[TARGET_USER_ID_KEY]),
      offered_player: NflPlayer.find(transfer_request_params[OFFERED_PLAYER_ID_KEY]),
      target_player: NflPlayer.find(transfer_request_params[TARGET_PLAYER_ID_KEY]),
      status: TransferRequest::STATUS_PENDING
    )
  end

  def validate_all_create_parameters(params)
    validate_all_parameters([TRANSFER_REQUEST_ID_KEY], params)
    validate_all_parameters(
      [
        OFFERING_USER_ID_KEY,
        TARGET_USER_ID_KEY,
        OFFERED_PLAYER_ID_KEY,
        TARGET_PLAYER_ID_KEY
      ],
      params[TRANSFER_REQUEST_ID_KEY]
    )
  end

  def find_and_resolve_transfer_request(transfer_request_id, action_type)
    transfer_request = TransferRequest.find(transfer_request_id)

    handle_swap(transfer_request) if action_type == ACTION_ACCEPT
    transfer_request.update!(status: TransferRequest::STATUS_REJECTED) if action_type == ACTION_REJECT
    transfer_request.destroy! if action_type == ACTION_CANCEL
  end

  def handle_swap(transfer_request)
    offered_game_week_team = transfer_request.offering_user.team_for_current_unlocked_game_week
    targeted_game_week_team = transfer_request.target_user.team_for_current_unlocked_game_week

    # Get the game_week_team_players
    offered_game_week_team_player = find_game_week_team_player(offered_game_week_team, transfer_request.offered_player)
    targeted_game_week_team_player = find_game_week_team_player(targeted_game_week_team, transfer_request.target_player)

    # Swap the game week teams
    offered_game_week_team_player.game_week_team = targeted_game_week_team
    targeted_game_week_team_player.game_week_team = offered_game_week_team

    # Save
    offered_game_week_team_player.save!
    targeted_game_week_team_player.save!

    # Change status
    transfer_request.update!(status: TransferRequest::STATUS_ACCEPTED)
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
