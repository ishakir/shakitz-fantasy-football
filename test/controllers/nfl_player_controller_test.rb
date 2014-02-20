require 'test_helper'

class NflPlayerControllerTest < ActionController::TestCase
  
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
  
  test "should assign players as a list of size 2" do
    
    players = get_assigns(:unpicked, :players)
    assert_equal players.size, 2, "List of NFL players is the wrong size"
    
  end
  
  test "should have Marshawn Lunch as the first element of the list of players" do
    
    players = get_assigns(:unpicked, :players)
    assert_equal players[0].name, "Marshawn Lunch", "The first player has the wrong name"
    
  end

end
