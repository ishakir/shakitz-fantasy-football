require 'test_helper'

class WaiverWireTest < ActiveSupport::TestCase
  test 'user must be present' do
    user = User.find(2)
    player_one = NflPlayer.find(3)
    player_two = NflPlayer.find(4)
    game_week = GameWeek.find(1)
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(
        offered_player: player_one,
        targeted_player: player_two,
        game_week: game_week,
        round: 1,
        incoming_priority: 1
      )
    end
  end
  
  test 'offered player must be present' do
    user = User.find(2)
    player_two = NflPlayer.find(4)
    game_week = GameWeek.find(1)
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(
        targeted_player: player_two,
        game_week: game_week,
        round: 1,
        incoming_priority: 1
      )
    end
  end
  
  test 'targeted player must be present' do
    user = User.find(2)
    player_one = NflPlayer.find(3)
    game_week = GameWeek.find(1)
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(
        offered_player: player_one,
        game_week: game_week,
        round: 1,
        incoming_priority: 1
      )
    end
  end
  
  test 'game week must be present' do
    user = User.find(2)
    player_one = NflPlayer.find(3)
    player_two = NflPlayer.find(4)
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(
        offered_player: player_one,
        targeted_player: player_two,
        round: 1,
        incoming_priority: 1
      )
    end
  end
  
  test 'round must be present' do
    user = User.find(2)
    player_one = NflPlayer.find(3)
    player_two = NflPlayer.find(4)
    game_week = GameWeek.find(1)
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(
        offered_player: player_one,
        targeted_player: player_two,
        game_week: game_week,
        incoming_priority: 1
      )
    end
  end
  
  test 'incoming priority must be present' do
    user = User.find(2)
    player_one = NflPlayer.find(3)
    player_two = NflPlayer.find(4)
    game_week = GameWeek.find(1)
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(
        offered_player: player_one,
        targeted_player: player_two,
        game_week: game_week,
        round: 1,
      )
    end
  end
  
  test "can't add multiple targets under same priority in same round" do
    user = User.find(2)
    player_one = NflPlayer.find(3)
    player_two = NflPlayer.find(4)
    game_week = GameWeek.find(1)
    params = { 
        user: user,
        offered_player: player_one,
        targeted_player: player_two,
        game_week: game_week,
        round: 1,
        incoming_priority: 1
      }
    WaiverWire.create!(params)
    assert_raise ActiveRecord::RecordNotUnique do
      (WaiverWire.create!(params))
    end
  end
  
end
