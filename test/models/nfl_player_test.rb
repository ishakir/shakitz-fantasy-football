# -*- encoding : utf-8 -*-
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

    NflPlayer.create!(name: expected_name, nfl_player_type: NflPlayerType.find(1), nfl_team: NflTeam.find(1))

    player = NflPlayer.last
    name = player.name

    assert_equal expected_name, name, "Found name '#{name}', expecting #{expected_name}"
  end

  test "we can update a player's name" do
    player = NflPlayer.find(1)

    new_name = 'Marshawn Launch'
    player.update!('name' => new_name)

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
    assert !player.save, 'Saved without a name and type non-D!'
  end

  test "can't create NflPlayer with a string that's the empty string" do
    NflPlayer.create(name: '', nfl_player_type: NflPlayerType.find(1), nfl_team: NflTeam.find(1))
    last_player = NflPlayer.last

    assert_equal LAST_NFL_PLAYER_NAME_IN_FIXTURES, last_player.name, 'Player with invalid name was created!'
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
    player.nfl_team = NflTeam.find(1)
    assert !player.save
  end

  test 'can create NflPlayer without a team' do
    player = NflPlayer.new
    player.name = 'My Dummy Name'
    player.nfl_player_type = NflPlayerType.find(1)
    assert player.save
  end

  test 'player responds to player_for_game_week' do
    player = NflPlayer.find(1)
    assert_respond_to player, :player_for_game_week
  end

  test 'player_for_game_week gives game_week_team with correct user' do
    player = NflPlayer.find(1)
    assert_equal player.id, player.player_for_game_week(1).nfl_player.id
  end

  test 'player_for_game_week gives game_week_team with correct game_week' do
    player = NflPlayer.find(1)
    assert_equal 1, player.player_for_game_week(1).game_week.number
  end

  test "can't give player_for_game_week zero" do
    player = NflPlayer.find(1)
    assert_raise ArgumentError do
      player.player_for_game_week(0)
    end
  end

  test "can't give team_for_game_week 18" do
    player = NflPlayer.find(1)
    assert_raise ArgumentError do
      player.player_for_game_week(18)
    end
  end

  test 'player_for_game_week accepts convertible strings' do
    player = NflPlayer.find(1)
    assert_equal 1, player.player_for_game_week('1').game_week.number
  end

  test 'can get current match player' do
    nfl_player = NflPlayer.find(1)
    assert_equal 1, nfl_player.player_for_current_game_week.game_week.number
  end
end
