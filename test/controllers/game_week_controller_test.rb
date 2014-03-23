require 'test_helper'

class GameWeekControllerTest < ActionController::TestCase
  
  # Gameweek team points
  test "should get get_gw_team_points" do
    can_view_action :get_gw_team_points, {:uid => 1, :gw => 1}
  end

  test "should get get_gw_team_points template" do
    can_view_template :get_gw_team_points, {:uid => 1, :gw => 1}
  end
  
  test "should get get_gw_team_points layout" do
    can_view_layout :get_gw_team_points, "layouts/application", {:uid => 1, :gw => 1}
  end
  
  test "should get number of team points for gameweek 1" do
    points = get_assigns :get_gw_team_points, :tally, {:uid => 1, :gw => 1}
    assert_equal GW_staffordpicks_points, points, "Incorrect points total" 
  end

  # Gameweek roster
  test "should get get_gw_roster" do
    can_view_action :get_gw_roster, {:uid => 1, :gw => 1}
  end
  
  test "should get get_gw_roster template" do
    can_view_template :get_gw_roster, {:uid => 1, :gw => 1}
  end
  
  test "should get get_gw_roster layout" do
    can_view_layout :get_gw_roster, "layouts/application", {:uid => 1, :gw => 1}
  end
  
  test "should reject with not found if user id doesn't exist" do
    get :get_gw_roster, {:uid => 1000, :gw => 1}
    assert_response :missing
  end
  
  test "should reject with not found if gameweek team doesn't exist for user" do
    get :get_gw_roster, {:uid => 1, :gw => 1000}
    assert_response :missing
  end
  
  test "should reject with unprocessable entity if uid not specified" do
    get :get_gw_roster, {:gw => 1}
    assert_response :unprocessable_entity
  end
  
  test "should reject with unprocessable entity if gw not specified" do
    get :get_gw_roster, {:uid => 1}
    assert_response :unprocessable_entity
  end
  
  test "should reject with unprocessable entity if no params specified" do
    get :get_gw_roster
    assert_response :unprocessable_entity
  end
  
  test "should get a roster" do
    assert_assigns_not_nil(:get_gw_roster, :roster, {:uid => 1, :gw => 1})
  end
  
  test "should get a roster of the correct size" do
    roster = get_assigns(:get_gw_roster, :roster, {:uid => 1, :gw => 1})
    assert_equal roster.size, 18
  end
  
  test "roster should consist of match_players" do
    roster = get_assigns(:get_gw_roster, :roster, {:uid => 1, :gw => 1})
    match_player = roster[0]
    assert_respond_to match_player, :qb_pick, "Elements of @roster not match players!"
  end
  
  # Gameweek player points
  test "should get get_gw_player_points" do
    can_view_action :get_gw_player_points, {:uid => 1, :gw => 1}
  end
  
  test "should get get_gw_player_points template" do
    can_view_template :get_gw_player_points, {:uid => 1, :gw => 1}
  end
  
  test "should get get_gw_player_points layout" do
    can_view_layout :get_gw_player_points, "layouts/application"
  end
  
  # Swap playing with benched
  
end
