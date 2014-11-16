require 'test_helper'
require 'points_strategy'

class PointsStrategyTest < ActiveSupport::TestCase
  test 'can get requested points strategy' do
    strategy_object = PointsStrategy.new('nfl', nil)
    assert_kind_of PointsStrategy::Nfl, strategy_object
  end

  test 'correct error if no such strategy' do
    assert_raise ArgumentError do
      PointsStrategy.new('stuff', nil)
    end
  end
end
