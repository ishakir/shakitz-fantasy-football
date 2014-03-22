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
  
  test "a game week team has a number of match players some of which are playing" do
    
    gameweekteam = GameWeekTeam.find(1)
    gwt_players = gameweekteam.game_week_team_players
    
    players_playing = Array.new
    players_not_playing = Array.new
    
    # Go through each game_week_team_player and put it's match player into the corresponding list
    gwt_players.each do |gwt_player|
      if(gwt_player.playing)
        players_playing.push(gwt_player.match_player)
      else
        players_not_playing.push(gwt_player.match_player)
      end
    end
    
    assert_equal players_playing.size, 10, "GameWeekTeam has the wrong number of match players playing"
    assert_equal players_not_playing.size, 8, "GameWeekTeam has the wrong number of match players not playing"
    
  end
  
end
