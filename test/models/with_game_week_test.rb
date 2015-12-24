# -*- encoding : utf-8 -*-
require 'test_helper'

class WithGameWeekTest < ActiveSupport::TestCase
  test 'current game week is current game week' do
    assert_equal 1, WithGameWeek.current_game_week
  end

  test 'current game week is still current game week after lock' do
    Timecop.travel(Time.zone.now + 4.days) do
      assert_equal 1, WithGameWeek.current_game_week
    end
  end

  test 'current game week is current game week a week in the future' do
    Timecop.travel(Time.zone.now + 7.days) do
      assert_equal 2, WithGameWeek.current_game_week
    end
  end

  test 'current unlocked game week is current game week if not locked' do
    assert_equal 1, WithGameWeek.current_unlocked_game_week
  end

  test 'current unlocked game week is next week if current is locked' do
    Timecop.travel(Time.zone.now + 4.days) do
      assert_equal 2, WithGameWeek.current_unlocked_game_week
    end
  end

  test 'current unlocked game week is next week if current is not locked' do
    Timecop.travel(Time.zone.now + 7.days) do
      assert_equal 2, WithGameWeek.current_unlocked_game_week
    end
  end
end
