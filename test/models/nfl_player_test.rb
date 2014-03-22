require 'test_helper'

class NflPlayerTest < ActiveSupport::TestCase
  
  test "we can request the players name" do
    
    player = NflPlayer.find(1)
    assert_respond_to player, :name, "NflPlayer won't respond to 'name' method"
    
  end
  
  test "we can request the players id" do
    
    player = NflPlayer.find(2)
    assert_respond_to player, :id, "NflPlayer won't respond to 'id' method"
    
  end
  
  test "we can check an existing players name is correct" do
    
    player = NflPlayer.find(1)
    
    name = player.name
    expectedName = "Marshawn Lunch"
    
    assert_equal expectedName, name, "Found name '#{name}', expecting #{expectedName}"
    
  end
  
  test "we can check an existing players id" do
    
    expectedId = 2
    
    player = NflPlayer.find(expectedId)
    id = player.id
    
    assert_equal expectedId, id, "Found id '#{id}', expecting #{expectedId}"
    
  end
  
  test "the players name is the same as set on create" do
    
    expectedName = "Aaron Brodgers"
    
    NflPlayer.create('name' => expectedName)
    
    player = NflPlayer.last
    name = player.name
    
    assert_equal expectedName, name, "Found name '#{name}', expecting #{expectedName}"
    
  end
  
  test "we can update a player's name" do
    
    player = NflPlayer.find(1)
    
    newName = "Marshawn Launch"
    player.update('name' => newName)
    
    alsoThePlayer = NflPlayer.find(1)
    name = alsoThePlayer.name
    
    assert_equal newName, name, "Found name '#{name}', expecting #{newName}"
    
  end
  
  test "we can delete a player" do
    
    player = NflPlayer.find(2)
    
    player.destroy
    
    assert_raise ActiveRecord::RecordNotFound do
      NflPlayer.find(2)
    end
    
  end
  
  test "can't save NflPlayer without a name" do
    
    player = NflPlayer.new
    assert !player.save, "Saved without a name!"
    
  end
  
  test "can't save NflPlayer with a string that's the empty name" do
    
    player = NflPlayer.new
    player.name = ""
    
    assert !player.save, "Saved with name as the empty string!"
    
  end
  
  test "can't create NflPlayer with a string that's the empty string" do
    
    player = NflPlayer.create(:name => "")
    lastPlayer = NflPlayer.last
    
    assert_equal "Ive really run out of inspiration", lastPlayer.name, "Player with invalid name was created!"
    
  end
  
  test "an NFL Player has an NFL team" do
    player = NflPlayer.find(2)
    team = player.nfl_team
    
    assert_equal team.name, "DETROIT!"
  end
  
end
