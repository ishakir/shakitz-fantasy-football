require 'test_helper'

class NflTeamTest < ActiveSupport::TestCase
  
  test "NFL team has a number of players" do
    team = NflTeam.find(1)
    assert_equal team.nfl_players.size, 9
  end
  
end
