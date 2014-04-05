require 'test_helper'

class MatchPlayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "can see player touchdown stat" do
    obj = MatchPlayer.find(1).nfl_player
    
    name = obj.name
    expectedName = "Marshawn Lunch"
    
    assert_equal expectedName, name, "Found name '#{name}', expecting #{expectedName}"
    
  end
  
  test "can see player stat is default from start" do
    obj = MatchPlayer.find(37).attributes
    obj.each do |key, value|
      if(key != "id" && key != "nfl_player_id" && key != "game_week_id" && key != "created_at" && key != "updated_at")
        assert_equal 0, value, "Incorrect default value, was #{value}"
      end
    end
  end
  
  test "a match player has two game week teams" do
    mp = MatchPlayer.find(1)
    assert_equal mp.game_week_teams.size, 2, "Didn't get the right number of gameweekteams for match player!"
  end
  
  test "match player is playing in a gameweekteam in one game week" do
    mp = MatchPlayer.find(1)
    gwps = mp.game_week_team_players
    gwp = gwps[0]
    assert gwp.playing, "Expected match player to be playing in gameweek team in week 1!"
  end
  
  test "match player is not playing in a gameweekteam in another game week" do
    mp = MatchPlayer.find(1)
    gwps = mp.game_week_team_players
    gwp = gwps[1]
    assert !gwp.playing, "Expected match player to not be playing in gameweek team in week 2!"
  end
  
  test "match player has a game week" do
    match_player = MatchPlayer.find(1)
    assert_equal match_player.game_week.number, 1, "MatchPlayer has the wrong GameWeek number!"
  end
  
  test "should get Marshawn Lunch's points for gameweek 1" do
    lunch_gw_one = MatchPlayer.find(1)
    assert_equal Match_Player_one_points, lunch_gw_one.points
  end
  
  test "should get Marshawn Lunch's points for gameweek 2" do
    lunch_gw_two = MatchPlayer.find(18)
    assert_equal Match_Player_two_points, lunch_gw_two.points
  end
  
  test "cannot create match player without game week" do
    match_player = MatchPlayer.new
    match_player.nfl_player = NflPlayer.find(1)
    assert !match_player.save
  end
  
  test "cannot create match player without nfl player" do
    match_player = MatchPlayer.new
    match_player.game_week = GameWeek.find(5)
    assert !match_player.save
  end
  
  test "can create match player with simply nfl player and game week" do
    match_player = MatchPlayer.new
    match_player.nfl_player = NflPlayer.find(1)
    match_player.game_week = GameWeek.find(5)
    assert match_player.save
  end
  
end
