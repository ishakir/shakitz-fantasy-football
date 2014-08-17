# -*- encoding : utf-8 -*-
require 'test_helper'

class GameWeekTest < ActiveSupport::TestCase
  test 'a game week has a number of match players' do
    game_weeks = GameWeek.where(number: 1)
    game_week = game_weeks.first
    assert_equal 41, game_week.match_players.size, "GameWeek didn't have the expected number of match players!"
  end

  test 'a game week has a number of game week teams' do
    game_week = GameWeek.find(1)
    assert_equal NUMBER_OF_USERS, game_week.game_week_teams.size, "GameWeek didn't have the expected number of game week teams!"
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
end
