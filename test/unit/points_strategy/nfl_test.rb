require 'test_helper'
require 'points_strategy/nfl'

class NflTest < ActiveSupport::TestCase
  CALCULATED_POINTS_MP_ONE = 120
  CALCULATED_POINTS_MP_TWO = 27

  DEFENCE_ZERO_POINTS         = 10
  DEFENCE_THREE_POINTS        = 7
  DEFENCE_TEN_POINTS          = 4
  DEFENCE_SEVENTEEN_POINTS    = 1
  DEFENCE_TWENTY_FOUR_POINTS  = 0
  DEFENCE_THIRTY_ONE_POINTS   = -1
  DEFENCE_THIRTY_EIGHT_POINTS = -4

  test "should get Marshawn Lunch's points for gameweek 1" do
    lunch_gw_one = MatchPlayer.find(1)
    points_strategy = PointsStrategy::Nfl.new(lunch_gw_one)
    assert_equal CALCULATED_POINTS_MP_ONE, points_strategy.calculate_points
  end

  test "should get Marshawn Lunch's points for gameweek 2" do
    lunch_gw_two = MatchPlayer.find(19)
    points_strategy = PointsStrategy::Nfl.new(lunch_gw_two)
    assert_equal CALCULATED_POINTS_MP_TWO, points_strategy.calculate_points
  end

  test 'defence conceding zero points should get ten' do
    zero_defence = MatchPlayer.find(125)
    points_strategy = PointsStrategy::Nfl.new(zero_defence)
    assert_equal DEFENCE_ZERO_POINTS, points_strategy.calculate_points
  end

  test 'defence conceding three points should get seven' do
    three_defence = MatchPlayer.find(126)
    points_strategy = PointsStrategy::Nfl.new(three_defence)
    assert_equal DEFENCE_THREE_POINTS, points_strategy.calculate_points
  end

  test 'defence conceding ten points should get 4' do
    ten_defence = MatchPlayer.find(127)
    points_strategy = PointsStrategy::Nfl.new(ten_defence)
    assert_equal DEFENCE_TEN_POINTS, points_strategy.calculate_points
  end

  test 'defence conceding seventeen points should get one' do
    seventeen_defence = MatchPlayer.find(128)
    points_strategy = PointsStrategy::Nfl.new(seventeen_defence)
    assert_equal DEFENCE_SEVENTEEN_POINTS, points_strategy.calculate_points
  end

  test 'defence conceding twenty_four points should get 0' do
    twenty_four_defence = MatchPlayer.find(129)
    points_strategy = PointsStrategy::Nfl.new(twenty_four_defence)
    assert_equal DEFENCE_TWENTY_FOUR_POINTS, points_strategy.calculate_points
  end

  test 'defence conceding thirty_four points should get minus one' do
    thirty_four_defence = MatchPlayer.find(130)
    points_strategy = PointsStrategy::Nfl.new(thirty_four_defence)
    assert_equal DEFENCE_THIRTY_ONE_POINTS, points_strategy.calculate_points
  end

  test 'defence conceding thirty_eight points should get ten' do
    thirty_eight_defence = MatchPlayer.find(131)
    points_strategy = PointsStrategy::Nfl.new(thirty_eight_defence)
    assert_equal DEFENCE_THIRTY_EIGHT_POINTS, points_strategy.calculate_points
  end
end
