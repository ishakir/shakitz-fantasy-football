# -*- encoding : utf-8 -*-
require 'test_helper'

class NflTeamTest < ActiveSupport::TestCase
  test 'NFL team has a number of players' do
    team = NflTeam.find(1)
    assert_equal 29, team.nfl_players.size
  end

  test 'NFL team cannot be created without a name' do
    team = NflTeam.new
    assert !team.save
  end

  test 'NFL team can be created with a name' do
    team = NflTeam.new
    team.name = 'San Didrego Udon'
    assert team.save
  end

  test 'NFL team name must be unique' do
    team = NflTeam.new
    team.name = 'Jog On Jaguars'
    assert !team.save
  end
end
