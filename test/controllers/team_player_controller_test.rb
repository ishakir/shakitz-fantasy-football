# -*- encoding : utf-8 -*-
require 'test_helper'

class TeamPlayerControllerTest < ActionController::TestCase
  DEFAULT_USER_ID = 5
  DEFAULT_PLAYER_ID = 10
  DEFAULT_GAMEWEEK = 1

  ###################################################
  # Tests for :add_player
  ###################################################
  test "can't add a player with incorrect user id" do
    post :add_player, user_id: 999, player_id: DEFAULT_PLAYER_ID
    assert_response :not_found
  end

  test "can't add a non-existent player" do
    post :add_player, user_id: DEFAULT_USER_ID, player_id: 999
    assert_response :not_found
  end

  test "can't add a player to a team that has 18 players" do
    assert_equal NUMBER_OF_PLAYING + NUMBER_OF_BENCHED,
                 User.find(1).team_for_game_week(DEFAULT_GAMEWEEK).match_players.size
    post :add_player, user_id: 1, player_id: DEFAULT_PLAYER_ID
    assert_response :unprocessable_entity
  end

  test "can't add a player to a team who already belongs to someone else" do
    post :add_player, user_id: DEFAULT_USER_ID, player_id: 21
    assert_response :success
    post :add_player, user_id: 2, player_id: 21
    assert_response :unprocessable_entity
  end

  test "can't add a player who has no match player entity" do
    post :add_player, user_id: DEFAULT_USER_ID, player_id: 80
    assert_response :not_found
  end

  test 'can add a player to a valid team with less than 18 players' do
    previous_size = User.find(DEFAULT_USER_ID).team_for_game_week(DEFAULT_GAMEWEEK).match_players.size
    post :add_player, user_id: DEFAULT_USER_ID, player_id: 22
    assert_response :success
    assert_equal previous_size + 1, User.find(DEFAULT_USER_ID).team_for_game_week(DEFAULT_GAMEWEEK).match_players.size
  end

  ###############################################
  # Tests for :progress_game_week
  ###############################################
  test 'progress_game_week should reject if game_week not supplied' do
    post :progress_game_week
    assert_response :unprocessable_entity
  end

  test 'progress_game_week copies all players into next game week team' do
    post :progress_game_week, game_week: 1
    assert_response :success

    game_week_team = GameWeekTeam.find(19)
    assert_equal 18, game_week_team.match_players.size
  end

  test 'progress_game_week copies the correct players into second game week team' do
    post :progress_game_week, game_week: 1
    assert_response :success

    game_week_team = GameWeekTeam.find(19)

    assert game_week_team.match_players.include?(MatchPlayer.find(60))
  end

  test 'playing status is maintained' do
    post :progress_game_week, game_week: 1
    assert_response :success

    game_week_team = GameWeekTeam.find(19)
    match_player = MatchPlayer.find(70)

    game_week_team_player = GameWeekTeamPlayer.where(game_week_team: game_week_team, match_player: match_player).first
    assert game_week_team_player.playing
  end
end
