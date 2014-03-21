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
    obj = MatchPlayer.find(1).attributes
    obj.each do |key, value|
      if(key != "id" && key != "nfl_player_id" && key != "created_at" && key != "updated_at")
        assert_equal 0, value, "Incorrect default value, was #{value}"
      end
    end
  end
end
