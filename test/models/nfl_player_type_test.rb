require 'test_helper'

class NflPlayerTypeTest < ActiveSupport::TestCase
  test "should get player type position" do
    position_type = NflPlayerType.find(1)
    assert_respond_to position_type, :position_type, "NflPlayerType won't respond to 'position_type' method"
  end
  
  test "should get player type id" do
    position_type = NflPlayerType.find(2)
    assert_respond_to position_type, :id, "NflPlayerType won't respond to 'id' method"
  end
  
  test "should fail when adding a player type with no type" do
    player_type = NflPlayerType.new
    assert !player_type.save
  end
  
  test "should fail when adding a player type with empty string" do
    player_type = NflPlayerType.new
    player_type.position_type = ""
    assert !player_type.save
  end
end
