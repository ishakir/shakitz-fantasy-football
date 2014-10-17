require 'test_helper'

class GameDaysControllerTest < ActionController::TestCase
  test "should reject if no player_id attribute" do
    get :which_team_has_player, game_week: 1, format: :json
    assert_response :unprocessable_entity
  end

  test "should reject if player does not exist" do
    get :which_team_has_player, player_id: 500, game_week: 1, format: :json
    assert_response :not_found
  end

  test "should reject if game_week is too high" do
    get :which_team_has_player, player_id: 1, game_week: 27, format: :json
    assert_response :unprocessable_entity
  end

  test "should reject if game_week is too low" do
    get :which_team_has_player, player_id: 1, game_week: -5, format: :json
    assert_response :unprocessable_entity
  end

  test "should return a null data object if player has no team" do
    get :which_team_has_player, player_id: 22, game_week: 1, format: :json
    response_json = JSON.parse(response.body)
    assert_nil response_json["data"]
  end

  test "should return player name if player has a team" do
    get :which_team_has_player, player_id: 23, game_week: 1, format: :json
    response_json = JSON.parse(response.body)
    assert_equal "Cooler User", response_json["data"]["name"]
  end

  test "should return player team name if player has a team" do
    get :which_team_has_player, player_id: 23, game_week: 1, format: :json
    response_json = JSON.parse(response.body)
    assert_equal "What A Rigmarole", response_json["data"]["team_name"]
  end

  test "should return playing status if player has a team" do
    get :which_team_has_player, player_id: 23, game_week: 1, format: :json
    response_json = JSON.parse(response.body)
    assert_equal false, response_json["data"]["playing"]
  end

  test "basic route should redirect with current game week" do
    get :show_no_game_week
    assert_redirected_to "/game_day/1"
  end

  test "show has page_game_week in assigns" do
    page_game_week = get_assigns :show, :page_game_week, game_week: 1
    assert_equal 1, page_game_week
  end

  test "show has page_game_week as an integer" do
    page_game_week = get_assigns :show, :page_game_week, game_week: 1
    assert_kind_of Integer, page_game_week
  end

  test "show puts all player data in assigns" do
    assert_assigns_not_nil :show, :player_data, game_week: 1
  end

  test "show puts all users into @users" do
    users = get_assigns :show, :users, game_week: 1
    assert_equal NUMBER_OF_USERS, users.size
  end

  test "users contains user data types" do
    users = get_assigns :show, :users, game_week: 1
    assert_kind_of User, users[0]
  end

  test "current_game_week is an assigns" do
    current_game_week = get_assigns :show, :current_game_week, game_week: 1
    assert_equal 1, current_game_week
  end

  test "current_game_week is an integer" do
    current_game_week = get_assigns :show, :current_game_week, game_week: 1
    assert_kind_of Integer, current_game_week
  end
end
