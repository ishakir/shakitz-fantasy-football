# -*- encoding : utf-8 -*-
require 'test_helper'

class TransferRequestControllerTest < ActionController::TestCase
  test 'create should reject if offering_user_id is not supplied' do
    post :create, target_user_id: 1, offered_player_id: 2, target_player_id: 3
    assert_response :unprocessable_entity
  end

  test 'create should reject if target_user_id is not supplied' do
    post :create, offering_user_id: 1, offered_player_id: 2, target_player_id: 3
    assert_response :unprocessable_entity
  end

  test 'create should reject if offered_player_id is not supplied' do
    post :create, offering_user_id: 1, target_user_id: 2, target_player_id: 3
    assert_response :unprocessable_entity
  end

  test 'create should reject if target_player_id is not supplied' do
    post :create, offering_user_id: 1, target_user_id: 2, offered_player_id: 3
    assert_response :unprocessable_entity
  end

  test 'create should reject if offering_user_id is invalid' do
    post :create, transfer_request: {
      offering_user_id: -2,
      target_user_id: 2,
      offered_player_id: 3,
      target_player_id: 4
    }
    assert_response :not_found
  end

  test "create should reject if target_user_id can't be found" do
    post :create, transfer_request: {
      offering_user_id: 1,
      target_user_id: 50_000,
      offered_player_id: 3,
      target_player_id: 4
    }
    assert_response :not_found
  end

  test 'create should reject if offered_player_id is invalid' do
    post :create, transfer_request: {
      offering_user_id: 1,
      target_user_id: 2,
      offered_player_id: 'a string',
      target_player_id: 4
    }
    assert_response :not_found
  end

  test "create should reject if target_player_id can't be found" do
    post :create, transfer_request: {
      offering_user_id: 1,
      target_user_id: 2,
      offered_player_id: 3,
      target_player_id: 50_000
    }
    assert_response :not_found
  end

  test 'if all are valid then a transfer request is created' do
    params = { offering_user_id: 1, target_user_id: 2, offered_player_id: 3, target_player_id: 4 }
    post :create, transfer_request: params
    assert_response :redirect

    transfer_request = TransferRequest.last
    assert_equal 1, transfer_request.offering_user.id
    assert_equal 2, transfer_request.target_user.id
    assert_equal 3, transfer_request.offered_player.id
    assert_equal 4, transfer_request.target_player.id
  end

  test 'status is set to pending after creating a new transfer request' do
    params = { offering_user_id: 1, target_user_id: 2, offered_player_id: 3, target_player_id: 4 }
    post :create, transfer_request: params
    assert_response :redirect

    assert_equal 'pending', TransferRequest.last.status
  end

  test 'create redirects to transfer page' do
    params = { offering_user_id: 1, target_user_id: 2, offered_player_id: 3, target_player_id: 4 }
    post :create, transfer_request: params
    assert_redirected_to '/transfer/status'
  end

  test "resolve should reject if action_type isn't specified" do
    post :resolve, transfer_request: { id: 1 }
    assert_response :unprocessable_entity
  end

  test 'resolve should reject if action_type is invalid' do
    post :resolve, transfer_request: { id: 1, action_type: 'shpoople' }
    assert_response :unprocessable_entity
  end

  test 'resolve should reject if id is wrong' do
    post :resolve, transfer_request: { id: 50_000, action_type: 'accept' }
    assert_response :not_found
  end

  test 'status changes to rejected if rejected' do
    post :resolve, transfer_request: { id: 2, action_type: 'reject' }
    assert_redirected_to controller: :transfer_request, action: :status

    assert_equal 'rejected', TransferRequest.find(2).status
  end

  test "users are swapped if it's accepted" do
    post :resolve, transfer_request: { id: 2, action_type: 'accept' }
    assert_redirected_to controller: :transfer_request, action: :status

    game_week_team_player_one = GameWeekTeamPlayer.find(55)
    game_week_team_player_two = GameWeekTeamPlayer.find(56)

    assert_equal 4, game_week_team_player_one.game_week_team.user.id
    assert_equal 3, game_week_team_player_two.game_week_team.user.id
  end

  test 'transfer status is changed to accepted if accepted' do
    post :resolve, transfer_request: { id: 2, action_type: 'accept' }
    assert_redirected_to controller: :transfer_request, action: :status

    assert_equal 'accepted', TransferRequest.find(2).status
  end

  test 'transfer request is destroyed when cancelled' do
    post :resolve, transfer_request: { id: 2, action_type: 'cancel' }
    assert_redirected_to controller: :transfer_request, action: :status

    assert_raise ActiveRecord::RecordNotFound do
      TransferRequest.find(2)
    end
  end

  test 'status returns a non nil object' do
    assert_assigns_not_nil(:status, @pending_transfers)
  end

  test 'status returns all of the pending transfer requests' do
    expected_size = TransferRequest.where(status: 'pending').length
    actual_size = get_assigns(:status, :pending_transfers).length
    assert_equal expected_size, actual_size
  end

  test 'status returns all of the completed transfer requests' do
    expected_size = TransferRequest.where.not(status: 'pending').length
    actual_size = get_assigns(:status, :completed_transfers).length
    assert_equal expected_size, actual_size
  end

  # Test that playing / not playing is switched between players
  # Check any other potential trades are cancelled
end
