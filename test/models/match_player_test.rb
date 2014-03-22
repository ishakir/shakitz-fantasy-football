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
    obj = MatchPlayer.find(19).attributes
    obj.each do |key, value|
      if(key != "id" && key != "nfl_player_id" && key != "created_at" && key != "updated_at")
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
    assert !gwp.playing, "Expected match player to bot be playing in gameweek team in week 2!"
  end
  
end
