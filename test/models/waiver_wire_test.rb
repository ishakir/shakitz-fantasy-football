require 'test_helper'

class WaiverWireTest < ActiveSupport::TestCase
  def setup
    @valid_params = {
      user: User.find(1),
      player_out: NflPlayer.find(3),
      player_in: NflPlayer.find(4),
      game_week: GameWeek.find(1),
      incoming_priority: 1
    }
  end

  test 'can add valid waiver wire request' do
    WaiverWire.create!(@valid_params)
    assert_equal User.find(1), WaiverWire.last.user
    assert_equal 1, WaiverWire.last.incoming_priority
  end

  test 'user must be present' do
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(@valid_params.except(:user))
    end
  end

  test 'offered player must be present' do
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(@valid_params.except(:player_out))
    end
  end

  test 'targeted player must be present' do
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(@valid_params.except(:player_in))
    end
  end

  test 'game week must be present' do
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(@valid_params.except(:game_week))
    end
  end

  test 'incoming priority must be present' do
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(@valid_params.except(:incoming_priority))
    end
  end

  test "can't add multiple targets under same priority in same round" do
    WaiverWire.create!(@valid_params)
    assert_raise ActiveRecord::RecordInvalid do
      (WaiverWire.create!(@valid_params))
    end
  end
end
