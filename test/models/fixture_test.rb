# -*- encoding : utf-8 -*-
require 'test_helper'

class FixtureTest < ActiveSupport::TestCase
  # Interface to this model
  test "fixture responds to home_team" do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :home_team
  end

  test "home_team is a game_week_team" do
    fixture = Fixture.find(1)
    assert_kind_of GameWeekTeam, fixture.home_team
  end

  test "fixture responds to away_team" do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :away_team
  end

  test "away_team is a game_week_team" do
    fixture = Fixture.find(1)
    assert_kind_of GameWeekTeam, fixture.away_team
  end

  test "fixture responds to opponent_of" do
    fixture = Fixture.find(1)
    assert_respond_to fixture, :opponent_of
  end

  ## Validations
  test "must have a home team" do
    assert_raise ActiveRecord::RecordInvalid do
      Fixture.create!(away_team: GameWeekTeam.find(1))
    end
  end

  test "must have an away team" do
    assert_raise ActiveRecord::RecordInvalid do
      Fixture.create!(home_team: GameWeekTeam.find(1))
    end
  end

  test "game_week_teams can have the same gameweek" do
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
  test "can get the opponent of one of the teams" do
    team_a = GameWeekTeam.find(1)
    team_b = GameWeekTeam.find(18)
    fixture = Fixture.create!(home_team: team_a, away_team: team_b)
    assert_equal team_b.id, fixture.opponent_of(team_a).id
  end

  test "opponent of is reflective" do
    team_a = GameWeekTeam.find(1)
    team_b = GameWeekTeam.find(18)
    fixture = Fixture.create!(home_team: team_a, away_team: team_b)
    assert_equal team_a.id, fixture.opponent_of(team_b).id
  end

  test "opponent_of throws ArgumentError if team not found" do
    assert_raise ArgumentError do
      fixture = Fixture.create!(home_team: GameWeekTeam.find(1), away_team: GameWeekTeam.find(18))
      fixture.opponent_of(GameWeekTeam.find(2))
    end
  end
end
