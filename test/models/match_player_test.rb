require 'test_helper'

class MatchPlayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "can see player touchdown stat" do
    obj = MatchPlayer.find(1).nfl_player
    puts(obj.name)
  end
end
