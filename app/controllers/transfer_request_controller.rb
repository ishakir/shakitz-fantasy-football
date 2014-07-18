# -*- encoding : utf-8 -*-
class TransferRequestController < ApplicationController
  REQUEST_USER_ID_KEY   = :request_user_id
  TARGET_USER_ID_KEY    = :target_user_id
  OFFERED_PLAYER_ID_KEY = :offered_player_id
  TARGET_PLAYER_ID_KEY  = :target_player_id

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

  def resolve
  end
end
