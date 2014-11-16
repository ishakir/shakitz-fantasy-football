# -*- encoding : utf-8 -*-
require 'test_helper'

class GameWeekTeamTest < ActiveSupport::TestCase
  STAFFORDS_PICKS_WEEK_1_BENCH_POINTS = 32
  STAFFORDS_PICKS_WEEK_3_BENCH_POINTS = 24

  # No tests for creating GWT with fixture, as fixtures will be generated
  # much later than the GWTs will be
  test 'game_week_team has an opponent' do
    game_week_team = GameWeekTeam.find(1)
    assert_respond_to game_week_team, :opponent
  end

  test 'opponent can be a GameWeekTeam' do
    game_week_team = GameWeekTeam.find(1)
    assert_kind_of GameWeekTeam, game_week_team.opponent
  end

  test 'opponent can be nil' do
    game_week_team = GameWeekTeam.find(5)
    assert_nil game_week_team.opponent
  end

  test 'correct opponent is returned' do
    game_week_team = GameWeekTeam.find(1)
    assert_equal 18, game_week_team.opponent.id
  end

  test 'game_week_team has a fixture' do
    game_week_team = GameWeekTeam.find(1)
    assert_respond_to game_week_team, :fixture
  end

  test 'fixture can be an Fixture' do
    game_week_team = GameWeekTeam.find(1)
    assert_kind_of Fixture, game_week_team.fixture
  end

  test 'game_week_team has head_to_head_result' do
    game_week_team = GameWeekTeam.find(1)
    assert_respond_to game_week_team, :head_to_head_result
  end

  test 'game_week_team has bench points' do
    game_week_team = GameWeekTeam.find(1)
    assert_respond_to game_week_team, :bench_points
  end

  test 'head_to_head_result can be won' do
    game_week_team = GameWeekTeam.find(2)
    assert_equal :drawn, game_week_team.head_to_head_result
  end

  test 'head_to_head result can be drawn' do
    game_week_team = GameWeekTeam.find(1)
    assert_equal :won, game_week_team.head_to_head_result
  end

  test 'head_to_head_result can be lost' do
    game_week_team = GameWeekTeam.find(18)
    assert_equal :lost, game_week_team.head_to_head_result
  end

  test 'fixture can be nil' do
    game_week_team = GameWeekTeam.find(3)
    assert_nil game_week_team.fixture
  end

  test 'the correct fixture is returned' do
    game_week_team = GameWeekTeam.find(1)
    assert_equal 1, game_week_team.fixture.id
  end

  test "we can't create a gameweek team without a user" do
    game_week_team = GameWeekTeam.new
    game_week_team.game_week = GameWeek.find(1)

    assert !game_week_team.save, 'Able to save gameweekteam without a user'
  end

  test "we can't create a gameweek team without a game week" do
    game_week_team = GameWeekTeam.new
    game_week_team.user = User.find(1)

    assert !game_week_team.save
  end

  test 'we can associate a gameweek team with a user via object' do
    usertwo = User.find(2)
    GameWeekTeam.find(20).destroy!
    GameWeekTeam.create!(game_week: GameWeek.find(3), user: usertwo)
    assert_equal USER_TWO_NO_GWTS, usertwo.game_week_teams.size, "User two's no. of gameweek teams not updated"
  end

  test 'we can associate a gameweek team with a user via id' do
    GameWeekTeam.find(20).destroy!
    GameWeekTeam.create!(game_week: GameWeek.find(3), user_id: 2)
    assert_equal USER_TWO_NO_GWTS, User.find(2).game_week_teams.size, "User two's no. of gameweek teams not updated"
  end

  test 'we change the user a gameweek team is associated with and the user who lost it has less gameweeks' do
    GameWeekTeam.find(35).destroy

    gameweekteam = GameWeekTeam.find(1)
    gameweekteam.update!(user_id: 3)

    assert_equal 16, User.find(1).game_week_teams.size, "User one' no of gameweek teams not updated"
  end

  test 'we change the user a gameweek team is associated with and the user who gained it has more gameweeks' do
    GameWeekTeam.find(35).destroy

    gameweekteam = GameWeekTeam.find(1)
    gameweekteam.update!(user_id: 3)

    assert_equal 17, User.find(3).game_week_teams.size, "User two's no of gameweek teams not updated"
  end

  test 'we delete a game week team and the associated user has one less gameweek team' do
    gameweekteam = GameWeekTeam.find(1)
    gameweekteam.destroy!

    assert_equal User.find(1).game_week_teams.size, 16, "Use one's no of gameweek teams not updated"
  end

  test 'a game week team has a number of match players' do
    gameweekteam = GameWeekTeam.find(1)
    matchplayers = gameweekteam.match_players

    assert_equal matchplayers.size, 18, 'GameWeekTeam has the wrong number of match players'
  end

  test 'can get all the gameweekteam players in a game week team' do
    gameweekteam = GameWeekTeam.find(1)
    gwt_players = gameweekteam.game_week_team_players

    assert_equal gwt_players.size, 18, 'GameWeekTeam has the wrong number of game week team players!'
  end

  test 'can get all the matchplayers in a gameweekteam' do
    gwt = GameWeekTeam.find(1)
    match_players = gwt.match_players

    assert_equal match_players.size, 18, 'GameWeekTeam has the wrong number of match players!'
  end

  test 'can get all the players who are playing in a gameweek team' do
    gameweekteam = GameWeekTeam.find(1)
    players_playing = gameweekteam.match_players_playing

    assert_equal players_playing.size, 10, 'GameWeekTeam has the wrong number of match players who are playing!'
  end

  test 'can get all the players who are not playing in a gameweek team' do
    gameweekteam = GameWeekTeam.find(1)
    players_not_playing = gameweekteam.match_players_benched

    assert_equal players_not_playing.size, 8, "GameWeekTeam has the wrong number of match players who aren't playing!"
  end

  test 'match player has a game week' do
    game_week_team = GameWeekTeam.find(16)
    assert_equal game_week_team.game_week.number, 16, 'GameWeekTeam has the wrong GameWeek number!'
  end

  test 'should get number of team points for gameweek 1' do
    game_week_team = GameWeekTeam.find(1)
    assert_equal GWT_STAFFORD_PICKS_POINTS, game_week_team.points, 'Incorrect points total'
  end

  test 'should get number of team points for gameweek 2' do
    game_week_team = GameWeekTeam.find(3)
    assert_equal GWT_TWO_POINTS, game_week_team.points
  end

  test 'should get total bench players points for gameweek 1' do
    game_week_team = GameWeekTeam.find(1)
    assert_equal STAFFORDS_PICKS_WEEK_1_BENCH_POINTS, game_week_team.bench_points
  end

  test 'should get total bench players points for gameweek 3' do
    game_week_team = GameWeekTeam.find(3)
    assert_equal STAFFORDS_PICKS_WEEK_3_BENCH_POINTS, game_week_team.bench_points
  end

  test "can't create gwt if user / game week combo isn't unique" do
    game_week_team = GameWeekTeam.new
    game_week_team.user = User.find(1)
    game_week_team.game_week = GameWeek.find(1)
    assert !game_week_team.save
  end

  test 'a game week team has correct number of active and benched players' do
    game_week_team = GameWeekTeam.find(1)
    playing_count = 0
    benched_count = 0
    game_week_team.match_players_playing.each do
      playing_count += 1
    end
    game_week_team.match_players_benched.each do
      benched_count += 1
    end
    assert_equal NUMBER_OF_PLAYING, playing_count
    assert_equal NUMBER_OF_BENCHED, benched_count
  end
end
