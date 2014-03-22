require 'test_helper'

class GameWeekTeamTest < ActiveSupport::TestCase
  
  test "we can't create a gameweek team without a user" do
    gameweekteam = GameWeekTeam.new
    gameweekteam.gameweek = 1
    
    assert !gameweekteam.save, "Able to save gameweekteam without a user"
  end
  
  test "we can associate a gameweek team with a user via object" do
    usertwo = User.find(2)
    GameWeekTeam.create(:gameweek => 1, :user => usertwo)
    assert_equal usertwo.game_week_teams.size, 1, "User two's no. of gameweek teams not updated"
  end
  
  test "we can associate a gameweek team with a user via id" do
    GameWeekTeam.create(:gameweek => 1, :user_id => 2)
    assert_equal User.find(2).game_week_teams.size, 1, "User two's no. of gameweek teams not updated"
  end
  
  test "we change the user a gameweek team is associated with and the user who lost it has less gameweeks" do
    gameweekteam = GameWeekTeam.find(1)
    gameweekteam.update(:user_id => 2)
    
    assert_equal User.find(1).game_week_teams.size, 16, "User one' no of gameweek teams not updated"
  end
  
  test "we change the user a gameweek team is associated with and the user who gained it has more gameweeks" do
    gameweekteam = GameWeekTeam.find(1)
    gameweekteam.update(:user_id => 2)
    
    assert_equal User.find(2).game_week_teams.size, 1, "User two's no of gameweek teams not updated"
  end
  
  test "we delete a game week team and the associated user has one less gameweek team" do
    gameweekteam = GameWeekTeam.find(1)
    gameweekteam.destroy()
    
    assert_equal User.find(1).game_week_teams.size, 16, "Use one's no of gameweek teams not updated"
  end
  
  test "a game week team has a number of match players" do
    
    gameweekteam = GameWeekTeam.find(1)
    matchplayers = gameweekteam.match_players
    
    assert_equal matchplayers.size, 18, "GameWeekTeam has the wrong number of match players"
    
  end
  
  test "can get all the gameweekteam players in a game week team" do
    
    gameweekteam = GameWeekTeam.find(1)
    gwt_players = gameweekteam.game_week_team_players
    
    assert_equal gwt_players.size, 18, "GameWeekTeam has the wrong number of game week team players!"
    
  end
  
  test "can get all the matchplayers in a gameweekteam" do
    
    gwt = GameWeekTeam.find(1)
    match_players = gwt.match_players
    
    assert_equal match_players.size, 18, "GameWeekTeam has the wrong number of match players!"
    
  end
  
  test "can get all the players who are playing in a gameweek team" do
    
    gameweekteam = GameWeekTeam.find(1)
    players_playing = gameweekteam.match_players_playing
    
    assert_equal players_playing.size, 10, "GameWeekTeam has the wrong number of match players who are playing!"
    
  end
  
  test "can get all the players who are not playing in a gameweek team" do
    
    gameweekteam = GameWeekTeam.find(1)
    players_not_playing = gameweekteam.match_players_benched
    
    assert_equal players_not_playing.size, 8, "GameWeekTeam has the wrong number of match players who aren't playing!"
    
  end
  
end
