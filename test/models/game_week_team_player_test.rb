require 'test_helper'

class GameWeekTeamPlayerTest < ActiveSupport::TestCase
  
  test "can get game week team player's match player" do
    
    game_week_team_player = GameWeekTeamPlayer.find(1)
    match_player = game_week_team_player.match_player
    
    assert_equal match_player.id, 1
    
  end
  
  test "can get game week team player's game week team" do
    
    game_week_team_player = GameWeekTeamPlayer.find(1)
    game_week_team = game_week_team_player.game_week_team
    
    assert_equal game_week_team.gameweek, 1
    
  end
  
end
