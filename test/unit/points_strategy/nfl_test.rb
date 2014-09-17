require 'test_helper'
require 'points_strategy/nfl'

class NflTest < ActiveSupport::TestCase
  test "should get Marshawn Lunch's points for gameweek 1" do
    lunch_gw_one = MatchPlayer.find(1)
    points_strategy = PointsStrategy::Nfl.new(lunch_gw_one)
    assert_equal MATCH_PLAYER_ONE_POINTS, points_strategy.calculate_points
  end

  test "should get Marshawn Lunch's points for gameweek 2" do
    lunch_gw_two = MatchPlayer.find(19)
    points_strategy = PointsStrategy::Nfl.new(lunch_gw_two)
    assert_equal MATCH_PLAYER_TWO_POINTS, points_strategy.calculate_points
  end
end
