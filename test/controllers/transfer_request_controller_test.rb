# -*- encoding : utf-8 -*-
require 'test_helper'

class TransferRequestControllerTest < ActionController::TestCase
  test "create should reject if request_user_id is not supplied" do
    post :create, target_user_id: 1, offered_player_id: 2, target_player_id: 3
    assert_response :unprocessable_entity
  end

  test "create should reject if target_user_id is not supplied" do
    post :create, request_user_id: 1, offered_player_id: 2, target_player_id: 3
    assert_response :unprocessable_entity
  end

  test "create should reject if offered_player_id is not supplied" do
    post :create, request_user_id: 1, target_user_id: 2, target_player_id: 3
    assert_response :unprocessable_entity
  end

  test "create should reject if target_player_id is not supplied" do
    post :create, request_user_id: 1, target_user_id: 2, offered_player_id: 3
    assert_response :unprocessable_entity
  end

  test "create should reject if request_user_id is invalid" do
    post :create, request_user_id: -2, target_user_id: 2, offered_player_id: 3, target_player_id: 4
    assert_response :not_found
  end

  test "create should reject if target_user_id can't be found" do
    post :create, request_user_id: 1, target_user_id: 50_000, offered_player_id: 3, target_player_id: 4
    assert_response :not_found
  end

  test "create should reject if offered_player_id is invalid" do
    post :create, request_user_id: 1, target_user_id: 2, offered_player_id: "a string", target_player_id: 4
    assert_response :not_found
  end

  test "create should reject if target_player_id can't be found" do
    post :create, request_user_id: 1, target_user_id: 2, offered_player_id: 3, target_player_id: 50_000
    assert_response :not_found
  end

  test "if all are valid then a transfer request is created" do
    post :create, request_user_id: 1, target_user_id: 2, offered_player_id: 3, target_player_id: 4
    assert_response :success

    transfer_request = TransferRequest.last
    assert_equal 1, transfer_request.request_user.id
    assert_equal 2, transfer_request.target_user.id
    assert_equal 3, transfer_request.offered_player.id
    assert_equal 4, transfer_request.target_player.id
  end
end
