require 'test_helper'

class NflPlayerTest < ActiveSupport::TestCase
  test 'we can request the players name' do
    player = NflPlayer.find(1)
    assert_respond_to player, :name, "NflPlayer won't respond to 'name' method"
  end

  test 'we can request the players id' do
    player = NflPlayer.find(2)
    assert_respond_to player, :id, "NflPlayer won't respond to 'id' method"
  end

  test 'we can check an existing players name is correct' do
    player = NflPlayer.find(1)

    name = player.name
    expected_name = 'Marshawn Lunch'

    assert_equal expected_name, name, "Found name '#{name}', expecting #{expected_name}"
  end

  test 'we can check an existing players id' do
    expected_id = 2

    player = NflPlayer.find(expected_id)
    id = player.id

    assert_equal expected_id, id, "Found id '#{id}', expecting #{expected_id}"
  end

  test 'the players name is the same as set on create' do
    expected_name = 'Aaron Brodgers'

    NflPlayer.create(name: expected_name, nfl_player_type: NflPlayerType.find(1))

    player = NflPlayer.last
    name = player.name

    assert_equal expected_name, name, "Found name '#{name}', expecting #{expected_name}"
  end

  test "we can update a player's name" do
    player = NflPlayer.find(1)

    new_name = 'Marshawn Launch'
    player.update('name' => new_name)

    also_the_player = NflPlayer.find(1)
    name = also_the_player.name

    assert_equal new_name, name, "Found name '#{name}', expecting #{new_name}"
  end

  test 'we can delete a player' do

    player = NflPlayer.find(2)

    player.destroy

    assert_raise ActiveRecord::RecordNotFound do
      NflPlayer.find(2)
    end

  end

  test "can't save NflPlayer without a name" do

    player = NflPlayer.new
    player.nfl_player_type = NflPlayerType.find(1)
    assert !player.save, 'Saved without a name!'

  end

  test "can't save NflPlayer with a string that's the empty name" do

    player = NflPlayer.new
    player.name = ''
    player.nfl_player_type = NflPlayerType.find(1)

    assert !player.save, 'Saved with name as the empty string!'

  end

  test "can't create NflPlayer with a string that's the empty string" do

    NflPlayer.create(name: '', nfl_player_type: NflPlayerType.find(1))
    last_player = NflPlayer.last

    assert_equal 'Michael Vicks', last_player.name, 'Player with invalid name was created!'

  end

  test 'an NFL Player has an NFL team' do
    player = NflPlayer.find(2)
    team = player.nfl_team

    assert_equal team.name, 'DETROIT!'
  end

  test 'an NFL Player has an NFL type' do
    player = NflPlayer.find(2)
    type = player.nfl_player_type

    assert_equal type.position_type, 'QB'
  end

  test "can't create NFLPlayer without NflPlayerType" do
    player = NflPlayer.new
    player.name = 'My Dummy Name'
    assert !player.save
  end
end
