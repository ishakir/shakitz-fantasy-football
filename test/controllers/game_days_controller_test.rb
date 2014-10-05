require 'test_helper'

class GameDaysControllerTest < ActionController::TestCase
  test "should reject if no player_id attribute" do
    post :which_team_has_player, game_week: 1
    assert_response :unprocessable_entity
  end

  test "should reject if player does not exist" do
    post :which_team_has_player, player_id: 500, game_week: 1
    assert_response :not_found
  end

  test "should reject if game_week is too high" do
    post :which_team_has_player, player_id: 1, game_week: 27
    assert_response :unprocessable_entity
  end

  test "should reject if game_week is too low" do
    post :which_team_has_player, player_id: 1, game_week: -5
    assert_response :unprocessable_entity
  end

  test "should return a null data object if player has no team" do
    post :which_team_has_player, player_id: 22, game_week: 1
    response_json = JSON.parse(response.body)
    assert_nil response_json["data"]
  end

  test "should return player name if player has a team" do
    post :which_team_has_player, player_id: 23, game_week: 1
    response_json = JSON.parse(response.body)
    assert_equal "Cooler User", response_json["data"]["name"]
  end

  test "should return player team name if player has a team" do
    post :which_team_has_player, player_id: 23, game_week: 1
    response_json = JSON.parse(response.body)
    assert_equal "What A Rigmarole", response_json["data"]["team_name"]
  end

  test "should return playing status if player has a team" do
    post :which_team_has_player, player_id: 23, game_week: 1
    response_json = JSON.parse(response.body)
    assert_equal false, response_json["data"]["playing"]
  end
end
