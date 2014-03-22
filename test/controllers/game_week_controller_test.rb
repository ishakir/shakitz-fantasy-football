require 'test_helper'

class GameWeekControllerTest < ActionController::TestCase
  test "should get get_gw_team_points" do
    can_view_action :get_gw_team_points, {:uid =>1, :gw=>1}
  end

  test "should get get_gw_roster" do
    can_view_action :get_gw_roster
  end

  test "should get get_gw_player_points" do
    can_view_action :get_gw_player_points
  end

  test "should get get_gw_team_points template" do
    can_view_template :get_gw_team_points, {:uid =>1, :gw=>1}
  end
  
  test "should get get_gw_roster template" do
    can_view_template :get_gw_roster
  end
  
  test "should get get_gw_player_points template" do
    can_view_template :get_gw_player_points
  end
  
  test "should get get_gw_team_points layout" do
    can_view_layout :get_gw_team_points, "layouts/application", {:uid =>1, :gw=>1}
  end
  
  test "should get get_gw_roster layout" do
    can_view_layout :get_gw_roster, "layouts/application"
  end
  
  test "should get get_gw_player_points layout" do
    can_view_layout :get_gw_player_points, "layouts/application"
  end
  
  test "should get number of team points for gameweek 1" do
    points = get_assigns :get_gw_team_points, :tally, {:uid => 1, :gw => 1}
    assert_equal GW_staffordpicks_points, points, "Incorrect points total" 
  end
end
