# -*- encoding : utf-8 -*-
require 'test_helper'

class GameWeekTeamPlayerTest < ActiveSupport::TestCase
  test "can get game week team player's match player" do
    game_week_team_player = GameWeekTeamPlayer.find(1)
    match_player = game_week_team_player.match_player

    assert_equal 1, match_player.id
  end

  test "can get game week team player's game week team" do
    game_week_team_player = GameWeekTeamPlayer.find(1)
    game_week_team = game_week_team_player.game_week_team

    assert_equal 1, game_week_team.game_week.number
  end

  test "can't create game week team player without game week team" do
    match_player = MatchPlayer.create!(nfl_player: NflPlayer.find(8), game_week: GameWeek.find(3))
    game_week_team_player = GameWeekTeamPlayer.new
    game_week_team_player.match_player = match_player

    assert !game_week_team_player.save, 'Able to save GameWeekTeamPlayer without GameWeekTeam!'
  end

  test "can't create game week team player without match player" do
    game_week_team = GameWeekTeam.find(26) # game_week_id: 9, user_id: 2

    game_week_team_player = GameWeekTeamPlayer.new
    game_week_team_player.game_week_team = game_week_team

    assert !game_week_team_player.save, 'Able to save GameWeekTeamPlayer without MatchPlayer'
  end

  test 'validates gameweek must be the same for team and match player' do
    # Create a GameWeekTeam and MatchPlayer
    game_week_team = GameWeekTeam.find(26) # game_week_id: 9, user_id: 2
    match_player = MatchPlayer.create!(game_week: GameWeek.find(8), nfl_player: NflPlayer.find(8))

    game_week_team_player = GameWeekTeamPlayer.new
    game_week_team_player.game_week_team = game_week_team
    game_week_team_player.match_player = match_player

    assert !game_week_team_player.save, 'Able to save gwtp with mp and gwt having different gameweeks!'
  end

  test 'allows creation if gameweek is the same for team and match player' do
    # Create a GameWeekTeam and MatchPlayer
    game_week_team = GameWeekTeam.find(20) # game_week_id: 3, user_id: 2
    match_player = MatchPlayer.create!(game_week: GameWeek.find(3), nfl_player: NflPlayer.find(16))

    game_week_team_player = GameWeekTeamPlayer.new
    game_week_team_player.game_week_team = game_week_team
    game_week_team_player.match_player = match_player

    assert game_week_team_player.save, 'Unable to save gwtp, despite mp and gwt having same gameweeks!'
  end

  test 'validates game_week, match_player combo must be unique' do
    game_week_team = GameWeekTeam.find(1)
    match_player = MatchPlayer.find(2)

    game_week_team_player = GameWeekTeamPlayer.new
    game_week_team_player.game_week_team = game_week_team
    game_week_team_player.match_player = match_player

    assert !game_week_team_player.save
  end
end
