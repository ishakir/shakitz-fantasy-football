require 'test_helper'

class NflPlayerControllerTest < ActionController::TestCase
  
  firstPlayerName = "Marshawn Lunch"
  
  ####################################
  # Tests for "show all"
  ####################################
  
  test "should get unpicked" do  
    can_view_action :unpicked
  end
  
  test "should return the right template" do
    can_view_template :unpicked
  end
  
  test "should return the right layout for the template" do
    can_view_layout :unpicked, "layouts/application"
  end
  
  test "should assign players, which is not nil" do
    assert_assigns_not_nil :unpicked, :players, "List of NFL players is nil"
  end
  
  test "should return correct number of unpicked players" do
    players = get_assigns(:unpicked, :unpicked_players)
    assert_equal NUMBER_OF_UNPICKED_NFL_PLAYERS, players.size, "List of unpicked NFL players is the wrong size"
  end
  
  test "should have Marshawn Lunch as the first element of the list of players" do
    players = get_assigns(:unpicked, :players)
    assert_equal firstPlayerName, players[0].name, "The first player has the wrong name"
  end
  
  ####################################
  # Tests for "show individual"
  ####################################
  
  test "should get back a good response if the id is valid" do
    can_view_action :show, {:id => 1}
  end
  
  test "should get back a bad response if the id is invalid" do
    get :show, {:id => -1}
    assert_response :missing
  end
  
  test "should get show template" do
    can_view_template :show, {:id => 1}
  end
  
  test "should get show layout" do
    can_view_layout :show, "layouts/application", {:id => 1}
  end
  
  test "should get an assigned player" do
    assert_assigns_not_nil :show, :player, {:id => 1}
  end
  
  test "should get assigned player's correct name" do
    player = get_assigns :show, :player, {:id => 1}
    assert_equal firstPlayerName, player.name, "Player's name is incorrect!"
  end
  
  test "should get assigned player's correct id" do
    id = 1
    
    player = get_assigns :show, :player, {:id => id}
    assert_equal id, player.id, "Player's id is incorrect!"
  end
  
end
