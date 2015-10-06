# -*- encoding : utf-8 -*-
require 'test_helper'

class GameWeekTest < ActiveSupport::TestCase
  test 'a game week has a number of match players' do
    game_weeks = GameWeek.where(number: 1)
    game_week = game_weeks.first
    assert_not_nil game_week.match_players, "GameWeek doesn't have match players!"
  end

  test 'a game week has a number of game week teams' do
    game_week = GameWeek.find(1)
    assert_equal NUMBER_OF_USERS, game_week.game_week_teams.size
  end

  test 'you cannot create a game week without a number' do
    game_week = GameWeek.new
    assert !game_week.save, 'Able to save a game week without a number!'
  end

  test 'you cannot create a game week with a number less than 1' do
    game_week = GameWeek.new
    game_week.number = 0
    assert !game_week.save
  end

  test 'you cannot create a game week with a negative number' do
    game_week = GameWeek.new
    game_week.number = -5
    assert !game_week.save
  end

  test 'you cannot create a game week with a number more than 17' do
    game_week = GameWeek.new
    game_week.number = 18
    assert !game_week.save
  end

  test 'game week can be created' do
    GameWeek.find(1).destroy!
    game_week = GameWeek.new
    game_week.number = 1
    assert game_week.save
  end

  test 'validation of game week number' do
    game_week = GameWeek.new
    game_week.number = 1
    assert !game_week.save
  end

  test 'that the game week is locked on a thursday before the 5pm game' do
    skip("Need to find a better way of faking start time that doesn't damage other stuff")
    # t = Time.new(2014, 11, 13, 20, 25, 0, '-05:00') # First game of week 11
    # assert GameWeek.find(11).locked?
  end

  test 'can get points for all users for a specific gameweek' do
    all_points = GameWeek.get_all_points_for_gameweek(1)
    assert all_points
  end

  test 'points for all users for a specific gameweek returns items for all users' do
    all_points = GameWeek.get_all_points_for_gameweek(1)
    assert_equal all_points.size, User.all.size
  end

  test 'points for all users for an invalid gameweek raises record not found' do
    assert_raise ActiveRecord::RecordNotFound do
      GameWeek.get_all_points_for_gameweek(25)
    end
  end

  test 'points for all users for with no arguments raises argument error' do
    assert_raise ArgumentError do
      GameWeek.get_all_points_for_gameweek
    end
  end
end
