# -*- encoding : utf-8 -*-
require 'test_helper'

class MatchPlayerTest < ActiveSupport::TestCase
  NON_STAT_ATTIBUTES = %w(id nfl_player_id game_week_id created_at updated_at).freeze

  test 'can see player touchdown stat' do
    obj = MatchPlayer.find(1).nfl_player

    name = obj.name
    expected_name = 'Marshawn Lunch'

    assert_equal expected_name, name, "Found name '#{name}', expecting #{expected_name}"
  end

  test 'can see player stat is default from start' do
    obj = MatchPlayer.find(37).attributes
    obj.each do |key, value|
      next if NON_STAT_ATTIBUTES.include?(key)
      assert_equal 0, value, "Incorrect default value for #{key}, was #{value}"
    end
  end

  test 'match player is playing in a gameweekteam in one game week' do
    mp = MatchPlayer.find(1)
    gwps = mp.game_week_team_players
    gwp = gwps[0]
    assert gwp.playing, 'Expected match player to be playing in gameweek team in week 1!'
  end

  test 'match player has a game week' do
    match_player = MatchPlayer.find(1)
    assert_equal match_player.game_week.number, 1, 'MatchPlayer has the wrong GameWeek number!'
  end

  test "should get Marshawn Lunch's points for gameweek 1" do
    lunch_gw_one = MatchPlayer.find(1)
    assert_equal MATCH_PLAYER_ONE_POINTS, lunch_gw_one.points
  end

  test "should get Marshawn Lunch's points for gameweek 2" do
    lunch_gw_two = MatchPlayer.find(19)
    assert_equal MATCH_PLAYER_TWO_POINTS, lunch_gw_two.points
  end

  test 'cannot create match player without game week' do
    match_player = MatchPlayer.new
    match_player.nfl_player = NflPlayer.find(1)
    assert !match_player.save
  end

  test 'cannot create match player without nfl player' do
    match_player = MatchPlayer.new
    match_player.game_week = GameWeek.find(5)
    assert !match_player.save
  end

  test 'can create match player' do
    match_player = MatchPlayer.new
    match_player.nfl_player = NflPlayer.find(19)
    match_player.game_week = GameWeek.find(2)
    assert match_player.save
  end

  test "can't create match player if another has same game_week and nfl_player" do
    match_player = MatchPlayer.new
    match_player.nfl_player = NflPlayer.find(1)
    match_player.game_week = GameWeek.find(1)
    assert !match_player.save
  end
end
