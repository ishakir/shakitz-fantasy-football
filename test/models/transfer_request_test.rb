# -*- encoding : utf-8 -*-
require 'test_helper'

class TransferRequestTest < ActiveSupport::TestCase
  def create_transfer_request(offering_user, target_user, offered_players, target_players)
    tr = TransferRequest.create!(offering_user: offering_user, target_user: target_user)
    offered_players.each do |offered_player|
      tr.transfer_request_players.create!(nfl_player: offered_player, offered: true)
    end
    target_players.each do |target_player|
      tr.transfer_request_players.create!(nfl_player: target_player, transfer_request: tr, offered: false)
    end
    # Save ensures we revalidate
    tr.save!
  end

  test 'transfer request responds to offering_user' do
    transfer_request = TransferRequest.find(1)
    assert_respond_to transfer_request, :offering_user
  end

  test 'transfer request responds to target_user' do
    transfer_request = TransferRequest.find(1)
    assert_respond_to transfer_request, :target_user
  end

  test 'transfer request responds to offered_player' do
    transfer_request = TransferRequest.find(1)
    assert_respond_to transfer_request, :offered_players
  end

  test 'transfer request responds to target_player' do
    transfer_request = TransferRequest.find(1)
    assert_respond_to transfer_request, :target_players
  end

  test 'transfer request responds to trade back game week' do
    transfer_request = TransferRequest.find(1)
    assert_respond_to transfer_request, :trade_back_game_week
  end

  test 'transfer request responds to pending' do
    transfer_request = TransferRequest.find(1)
    assert_respond_to transfer_request, :status
  end

  test 'default status is pending' do
    transfer_request = TransferRequest.find(1)
    assert_equal 'pending', transfer_request.status
  end

  test 'a transfer request can have accepted status' do
    transfer_request = TransferRequest.find(4)
    assert_equal 'accepted', transfer_request.status
  end

  test 'a transfer request can have rejected status' do
    transfer_request = TransferRequest.find(5)
    assert 'rejected', transfer_request.status
  end

  test 'a transfer request can have cancelled status' do
    transfer_request = TransferRequest.find(6)
    assert_equal 'cancelled', transfer_request.status
  end

  test 'can change status' do
    transfer_request = TransferRequest.find(1)
    transfer_request.update!(status: TransferRequest::STATUS_ACCEPTED)
    assert_equal 'accepted', transfer_request.status
  end

  test 'cant change status to something random' do
    transfer_request = TransferRequest.find(1)
    assert_raise ActiveRecord::RecordInvalid do
      transfer_request.update!(status: 'gobbledigook')
    end
  end

  test 'transfer request gives correct trade back gameweek' do
    transfer_request = TransferRequest.find(2)
    assert_equal 1, transfer_request.trade_back_game_week.number
  end

  test 'transfer request gives the correct offering_user' do
    assert_equal 1, TransferRequest.find(1).offering_user.id
  end

  test 'transfer request gives the correct target_user' do
    assert_equal 2, TransferRequest.find(1).target_user.id
  end

  test 'transfer request gives the correct offered_player' do
    assert_equal 1, TransferRequest.find(1).offered_players[0].id
  end

  test 'transfer request gives the correct target_player' do
    assert_equal 2, TransferRequest.find(1).target_players[0].id
  end

  test 'offering_user must be present' do
    user = User.find(1)
    player_one = NflPlayer.find(1)
    player_two = NflPlayer.find(2)
    assert_raise ActiveRecord::RecordInvalid do
      TransferRequest.create!(
        target_user: user
      )
    end
  end

  test 'target_user must be present' do
    user = User.find(2)
    player_one = NflPlayer.find(3)
    player_two = NflPlayer.find(4)
    assert_raise ActiveRecord::RecordInvalid do
      TransferRequest.create!(
        offering_user: user
      )
    end
  end

  test 'offered_player must be present' do
    user_one = User.find(3)
    user_two = User.find(4)
    player = NflPlayer.find(5)
    assert_raise ActiveRecord::RecordInvalid do
      create_transfer_request(
        user_one, user_two, [], [player]
      )
    end
  end

  test 'target_player must be present' do
    user_one = User.find(5)
    user_two = User.find(6)
    player = NflPlayer.find(6)
    assert_raise ActiveRecord::RecordInvalid do
      create_transfer_request(
        user_one, user_two, [player], []
      )
    end
  end

  test 'users cannot be the same' do
    user = User.find(1)
    player_one = NflPlayer.find(1)
    player_two = NflPlayer.find(2)
    assert_raise ActiveRecord::RecordInvalid do
      create_transfer_request(
        user, user, [player_one], [player_two]
      )
    end
  end

  test 'players cannot be the same' do
    user_one = User.find(1)
    user_two = User.find(2)
    player = NflPlayer.find(1)
    assert_raise ActiveRecord::RecordInvalid do
      create_transfer_request(
        user_one, user_two, [player], [player]
      )
    end
  end
end
