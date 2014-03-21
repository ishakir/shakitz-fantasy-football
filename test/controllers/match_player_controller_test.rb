require 'test_helper'

class MatchPlayerControllerTest < ActionController::TestCase
  test "should get rushing" do
    can_view_action :rushing
  end

  test "should get passing" do
    can_view_action :passing
  end

  test "should get defense" do
     can_view_action :defense
  end

  test "should get kicker" do
    can_view_action :kicker
  end

  test "should get show" do
    can_view_action :show
  end

end
