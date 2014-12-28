# -*- encoding : utf-8 -*-
require 'test_helper'

class TransferRequestTest < ActiveSupport::TestCase
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
    assert_respond_to transfer_request, :offered_player
  end

  test 'transfer request responds to target_player' do
    transfer_request = TransferRequest.find(1)
    assert_respond_to transfer_request, :target_player
  end

  test 'transfer request gives the correct offering_user' do
    assert_equal 1, TransferRequest.find(1).offering_user.id
  end

  test 'transfer request gives the correct target_user' do
    assert_equal 2, TransferRequest.find(1).target_user.id
  end

  test 'transfer request gives the correct offered_player' do
    assert_equal 1, TransferRequest.find(1).offered_player.id
  end

  test 'transfer request gives the correct target_player' do
    assert_equal 2, TransferRequest.find(1).target_player.id
  end

  test 'offering_user must be present' do
    user = User.find(1)
    player_one = NflPlayer.find(1)
    player_two = NflPlayer.find(2)
    assert_raise ActiveRecord::RecordInvalid do
      TransferRequest.create!(
        target_user: user,
        offered_player: player_one,
        target_player: player_two
      )
    end
  end

  test 'target_user must be present' do
    user = User.find(2)
    player_one = NflPlayer.find(3)
    player_two = NflPlayer.find(4)
    assert_raise ActiveRecord::RecordInvalid do
      TransferRequest.create!(
        offering_user: user,
        offered_player: player_one,
        target_player: player_two
      )
    end
  end

  test 'offered_player must be present' do
    user_one = User.find(3)
    user_two = User.find(4)
    player = NflPlayer.find(5)
    assert_raise ActiveRecord::RecordInvalid do
      TransferRequest.create!(
        offering_user: user_one,
        target_user: user_two,
        target_player: player
      )
    end
  end

  test 'target_player must be present' do
    user_one = User.find(5)
    user_two = User.find(6)
    player = NflPlayer.find(6)
    assert_raise ActiveRecord::RecordInvalid do
      TransferRequest.create!(
        offering_user: user_one,
        target_user: user_two,
        offered_player: player
      )
    end
  end

  test 'users cannot be the same' do
    user = User.find(1)
    player_one = NflPlayer.find(1)
    player_two = NflPlayer.find(2)
    assert_raise ActiveRecord::RecordInvalid do
      TransferRequest.create!(
        offering_user: user,
        target_user: user,
        offered_player: player_one,
        target_player: player_two
      )
    end
  end

  test 'players cannot be the same' do
    user_one = User.find(1)
    user_two = User.find(2)
    player = NflPlayer.find(1)
    assert_raise ActiveRecord::RecordInvalid do
      TransferRequest.create!(
        offering_user: user_one,
        target_user: user_two,
        offered_player: player,
        target_player: player
      )
    end
  end
end
