# -*- encoding : utf-8 -*-
require 'test_helper'

class FixtureTest < ActiveSupport::TestCase
  # Interface to this model
  test 'fixture responds to home_team' do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :home_team
  end

  test 'home_team is a game_week_team' do
    fixture = Fixture.find(1)
    assert_kind_of GameWeekTeam, fixture.home_team
  end

  test 'fixture responds to away_team' do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :away_team
  end

  test 'away_team is a game_week_team' do
    fixture = Fixture.find(1)
    assert_kind_of GameWeekTeam, fixture.away_team
  end

  test 'fixture responds to opponent_of' do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :opponent_of
  end

  test 'fixture responds to won_by?' do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :won_by?
  end

  test 'fixture responds to drawn?' do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :drawn?
  end

  test 'fixture responds to lost_by?' do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :lost_by?
  end

  test 'fixture responds to winner' do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :winner
  end

  test 'winner is GameWeekTeam' do
    fixture = Fixture.find(1)
    assert_kind_of GameWeekTeam, fixture.winner
  end

  test 'fixture responds to loser' do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :loser
  end

  test 'loser is GameWeekTeam' do
    fixture = Fixture.find(1)
    assert_kind_of GameWeekTeam, fixture.loser
  end

  test 'fixture responds to assert_team_is_playing' do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :assert_team_is_playing
  end

  ## Validations
  test 'must have a home team' do
    assert_raise ActiveRecord::RecordInvalid do
      Fixture.create!(away_team: GameWeekTeam.find(1))
    end
  end

  test 'must have an away team' do
    assert_raise ActiveRecord::RecordInvalid do
      Fixture.create!(home_team: GameWeekTeam.find(1))
    end
  end

  test 'game_week_teams can have the same gameweek' do
    assert_nothing_raised do
      Fixture.create!(home_team: GameWeekTeam.find(1), away_team: GameWeekTeam.find(18))
    end
  end

  test "game_week_teams can't have a different gameweek" do
    assert_raise ActiveRecord::RecordInvalid do
      Fixture.create!(home_team: GameWeekTeam.find(1), away_team: GameWeekTeam.find(19))
    end
  end

  test "game_week_teams can't have the same user" do
    assert_raise ActiveRecord::RecordInvalid do
      Fixture.create!(home_team: GameWeekTeam.find(1), away_team: GameWeekTeam.find(1))
    end
  end

  ## Custom Methods
  test 'can get the opponent of one of the teams' do
    team_a = GameWeekTeam.find(1)
    team_b = GameWeekTeam.find(18)
    fixture = Fixture.create!(home_team: team_a, away_team: team_b)
    assert_equal team_b.id, fixture.opponent_of(team_a).id
  end

  test 'opponent of is reflective' do
    team_a = GameWeekTeam.find(1)
    team_b = GameWeekTeam.find(18)
    fixture = Fixture.create!(home_team: team_a, away_team: team_b)
    assert_equal team_a.id, fixture.opponent_of(team_b).id
  end

  test 'opponent_of throws ArgumentError if team not found' do
    fixture = Fixture.create!(home_team: GameWeekTeam.find(1), away_team: GameWeekTeam.find(18))
    assert_raise ArgumentError do
      fixture.opponent_of(GameWeekTeam.find(2))
    end
  end

  test 'can get the winner as a game_week_team' do
    fixture = Fixture.find(1)
    assert 1, fixture.winner.id
  end

  test 'can get the loser as a game_week_team' do
    fixture = Fixture.find(1)
    assert 18, fixture.loser.id
  end

  test 'winner returns nil if no-one won' do
    fixture = Fixture.find(2)
    assert_nil fixture.winner
  end

  test 'loser returns nil if no-one won' do
    fixture = Fixture.find(2)
    assert_nil fixture.loser
  end

  test "we can tell if a match wasn't drawn" do
    fixture = Fixture.find(1)
    assert !fixture.drawn?
  end

  test 'we can tell if a match was drawn' do
    fixture = Fixture.find(2)
    assert fixture.drawn?
  end

  test 'can get that one team won' do
    fixture = Fixture.find(1)
    assert fixture.won_by?(GameWeekTeam.find(1))
  end

  test 'can get that one team did not win' do
    fixture = Fixture.find(1)
    assert !fixture.won_by?(GameWeekTeam.find(18))
  end

  test 'won_by? throws ArgumentError if team not found' do
    fixture = Fixture.find(1)
    assert_raise ArgumentError do
      fixture.won_by?(GameWeekTeam.find(2))
    end
  end

  test 'can get that one team lost' do
    fixture = Fixture.find(1)
    assert fixture.lost_by?(GameWeekTeam.find(18))
  end

  test 'can get that one team did not lose' do
    fixture = Fixture.find(1)
    assert !fixture.lost_by?(GameWeekTeam.find(1))
  end

  test 'lost_by? throws ArgumentError if team not found' do
    fixture = Fixture.find(1)
    assert_raise ArgumentError do
      fixture.lost_by?(GameWeekTeam.find(2))
    end
  end

  test 'assert_team_is_playing raises nothing if given home_team' do
    fixture = Fixture.find(1)
    assert_nothing_raised do
      fixture.assert_team_is_playing(GameWeekTeam.find(1))
    end
  end

  test 'assert_team_is_playing raises nothing if given away_team' do
    fixture = Fixture.find(1)
    assert_nothing_raised do
      fixture.assert_team_is_playing(GameWeekTeam.find(18))
    end
  end

  test 'assert_team_is_playing raises ArgumentError if team is not playing' do
    fixture = Fixture.find(1)
    assert_raise ArgumentError do
      fixture.assert_team_is_playing(GameWeekTeam.find(2))
    end
  end
end
