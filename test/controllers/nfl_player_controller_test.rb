# -*- encoding : utf-8 -*-
require 'test_helper'

class NflPlayerControllerTest < ActionController::TestCase
  ####################################
  # Tests for "show all"
  ####################################

  # test 'should get unpicked' do
  #   can_view_action :unpicked
  # end

  # test 'should return the right template' do
  #   can_view_template :unpicked
  # end

  # test 'should return the right layout for the template' do
  #   can_view_layout :unpicked, 'layouts/application'
  # end

  # test 'should assign players, which is not nil' do
  #   assert_assigns_not_nil :unpicked, :players, 'List of NFL players is nil'
  # end

  # test 'should return correct number of unpicked players' do
  #   players = get_assigns(:unpicked, :unpicked_players)
  #   assert_equal NUMBER_OF_UNPICKED_NFL_PLAYERS, players.size, 'List of unpicked NFL players is the wrong size'
  # end

  # test 'should have Marshawn Lunch as the first element of the list of players' do
  #   players = get_assigns(:unpicked, :players)
  #   assert_equal first_player_name, players[0].name, 'The first player has the wrong name'
  # end

  ####################################
  # Tests for "show individual"
  ####################################

  # test 'should get back a good response if the id is valid' do
  #   can_view_action :show, id: 1
  # end

  # test 'should get back a bad response if the id is invalid' do
  #   get :show, id: -1
  #   assert_response :missing
  # end

  # test 'should get show template' do
  #   can_view_template :show, id: 1
  # end

  # test 'should get show layout' do
  #   can_view_layout :show, 'layouts/application', id: 1
  # end

  # test 'should get an assigned player' do
  #   assert_assigns_not_nil :show, :player, id: 1
  # end

  # test "should get assigned player's correct name" do
  #   player = get_assigns :show, :player, id: 1
  #   assert_equal first_player_name, player.name, "Player's name is incorrect!"
  # end

  # test "should get assigned player's correct id" do
  #   id = 1

  #   player = get_assigns :show, :player, id: id
  #   assert_equal id, player.id, "Player's id is incorrect!"
  # end

  ##################################
  # Tests for create
  ##################################
  test 'should reject if no type attribute' do
    post :create, name: 'A name', team: 'DETROIT!', id: 'stuff'
    assert_response :unprocessable_entity
  end

  test 'should reject if no team attribute' do
    post :create, name: 'A name', type: 'K', id: 'stuff'
    assert_response :unprocessable_entity
  end

  test "should reject if team doesn't exist" do
    post :create, name: 'A name', team: 'XXX', type: 'K', id: 'stuff'
    assert_response :not_found
  end

  test "should reject if type is not D and id isn't specified" do
    post :create, name: 'A name', team: 'XXX', type: 'K'
    assert_response :unprocessable_entity
  end

  test "should reject if type doesn't exist" do
    post :create, name: 'A name', type: 'NNN', team: 'DETROIT!', id: 'stuff'
    assert_response :not_found
  end

  test 'should reject if type is D and id is specified' do
    post :create, name: 'A name', type: 'D', team: 'DETROIT!', id: 'stuff'
    assert_response :unprocessable_entity
  end

  test "should reject if name isn't specified" do
    post :create, type: 'K', team: 'DETROIT!', id: 'stuff'
    assert_response :unprocessable_entity
  end

  test 'should create a player' do
    post :create, name: 'A name', team: 'DETROIT!', type: 'K', id: 'stuff'
    assert_response :success

    nfl_player = NflPlayer.last

    assert_equal 'A name', nfl_player.name
    assert_equal 'DETROIT!', nfl_player.nfl_team.name
    assert_equal 'K', nfl_player.nfl_player_type.position_type
    assert_equal 'stuff', nfl_player.nfl_id
  end

  test 'should create a D player' do
    post :create, name: 'A name', team: 'DETROIT!', type: 'D'
    assert_response :success

    nfl_player = NflPlayer.last

    assert_equal 'A name', nfl_player.name
    assert_equal 'DETROIT!', nfl_player.nfl_team.name
    assert_equal 'D', nfl_player.nfl_player_type.position_type
  end

  test 'should create a match_player for all weeks' do
    post :create, name: 'Defence', team: 'DETROIT!', type: 'D'

    nfl_player = NflPlayer.last

    assert_equal 17, nfl_player.match_players.size
  end
  ##################################
  # Tests for update
  ##################################
  test 'should update name' do
    put :update, id: 1, name: 'changed'
    assert_response :success

    nfl_player = NflPlayer.find(1)
    assert_equal 'changed', nfl_player.name
  end

  test 'should update team' do
    put :update, id: 1, team: 'DETROIT!'
    assert_response :success

    nfl_player = NflPlayer.find(1)
    assert_equal 'DETROIT!', nfl_player.nfl_team.name
  end

  test 'should update type' do
    put :update, id: 1, type: 'QB'
    assert_response :success

    nfl_player = NflPlayer.find(1)
    assert_equal 'QB', nfl_player.nfl_player_type.position_type
  end

  test "if player doesn't exist, request is rejected" do
    put :update, id: 33_392, name: 'hello'
    assert_response :not_found
  end

  test "if team doesn't exist, request is rejected" do
    put :update, id: 1, team: 'Another team'
    assert_response :not_found
  end

  test "if type doesn't exist, request is rejected" do
    put :update, id: 1, type: 'IK'
    assert_response :not_found
  end

  test 'should reject if no arguments supplied' do
    put :update, id: 1
    assert_response :unprocessable_entity
  end

  ##################################
  # Tests for update_stats
  ##################################
  STATS_HASH = {
    passing_yards: 500,
    passing_tds: 7,
    passing_twoptm: 1,
    rushing_yards: 21,
    rushing_tds: 1,
    rushing_twoptm: 3,
    receiving_yards: 87,
    receiving_tds: 3,
    receiving_twoptm: 1,
    field_goals_kicked: 7,
    extra_points_kicked: 20
  }.freeze

  test 'should reject no player attribute' do
    post :update_stats, format: :json, game_week: 1
    assert_response :unprocessable_entity
    parsed_body = JSON.parse(response.body)
    assert_equal 1, parsed_body['messages'].size
    assert_equal 1, parsed_body['messages'][0]['id']
  end

  test 'should reject if no id_info' do
    validate_stats_update_response('no_identification_info', :unprocessable_entity, [1])
  end

  test 'should reject if id_info contains no content' do
    validate_stats_update_response('no_identification_data', :unprocessable_entity, [1])
  end

  test 'should reject if only type is supplied' do
    validate_stats_update_response('only_type', :unprocessable_entity, [2])
  end

  test 'should reject is only team is supplied' do
    validate_stats_update_response('only_team', :unprocessable_entity, [3])
  end

  test 'should reject if id is incorrect' do
    validate_stats_update_response('invalid_id', :not_found, [11])
  end

  test 'should reject if name cannot be found' do
    validate_stats_update_response('name_doesnt_exist', :not_found, [12])
  end

  test 'should reject if name / type combination cannot be found' do
    validate_stats_update_response('name_type_combo_doesnt_exist', :not_found, [13])
  end

  test 'should reject if name / team combination cannot be found' do
    validate_stats_update_response('name_team_combo_doesnt_exist', :not_found, [14])
  end

  test 'should reject if team / type combination cannot be found' do
    validate_stats_update_response('team_type_combo_doesnt_exist', :not_found, [15])
  end

  test 'should reject if name / team / type combination cannot be found' do
    validate_stats_update_response('name_team_type_combo_doesnt_exist', :not_found, [16])
  end

  test 'should reject if multiple players have the same name' do
    validate_stats_update_response('multiple_players_with_name', :not_found, [21])
  end

  test 'should reject if multiple players have the same name / type' do
    validate_stats_update_response('multiple_players_with_name_type_combo', :not_found, [22])
  end

  test 'should reject if multiple players have the same name / team' do
    validate_stats_update_response('multiple_players_with_name_team_combo', :not_found, [23])
  end

  test 'should reject if multiple players have the same team / type' do
    validate_stats_update_response('multiple_players_with_team_type_combo', :not_found, [24])
  end

  test 'should reject if multiple players have the same name / team / type' do
    validate_stats_update_response('multiple_players_with_name_type_team_combo', :not_found, [25])
  end

  test 'should warn if id specified but name is wrong' do
    validate_stats_update_response('inconsistant_name', :success, [51])
  end

  test 'should warn if id specified but team is wrong' do
    validate_stats_update_response('inconsistant_team', :success, [53])
  end

  test 'should warn if id specified but type is wrong' do
    validate_stats_update_response('inconsistant_type', :success, [52])
  end

  test 'should warn if id specified but name and team are wrong' do
    validate_stats_update_response('inconsistant_name_team', :success, [51, 53])
  end

  test 'should warn if id specified but name and type are wrong' do
    validate_stats_update_response('inconsistant_name_type', :success, [51, 52])
  end

  test 'should warn if id specified but team and type are wrong' do
    validate_stats_update_response('inconsistant_team_type', :success, [52, 53])
  end

  test 'should warn if id specified but name, team and type are wrong' do
    validate_stats_update_response('inconsistant_name_team_type', :success, [51, 52, 53])
  end

  test 'should update passing yards even if name is inconsistant' do
    validate_stats_update_response('inconsistant_name_pass_yd', :success, [51])
    assert_equal(300, NflPlayer.find(21).player_for_game_week(1).passing_yards)
  end

  test 'should update passing touchdowns even if team is inconsistant' do
    validate_stats_update_response('inconsistant_team_pass_td', :success, [53])
    assert_equal(5, NflPlayer.find(21).player_for_game_week(1).passing_tds)
  end

  test 'should update passing two point conversions even if type is inconsistant' do
    validate_stats_update_response('inconsistant_type_pass_twoptm', :success, [52])
    assert_equal(2, NflPlayer.find(21).player_for_game_week(1).passing_twoptm)
  end

  test 'should update all stats for id finder' do
    validate_stats_update_response('id_all_stats', :success, [])
    match_player = NflPlayer.find(21).player_for_game_week(1)
    check_stats(
      match_player,
      STATS_HASH
    )
  end

  test 'should update all stats for name finder' do
    validate_stats_update_response('name_all_stats', :success, [])
    match_player = NflPlayer.find(22).player_for_game_week(1)
    check_stats(
      match_player,
      STATS_HASH
    )
  end

  test 'should update all stats for team type finder' do
    validate_stats_update_response('team_type_all_stats', :success, [])
    match_player = NflPlayer.find(10).player_for_game_week(1)
    check_stats(
      match_player,
      STATS_HASH
    )
  end

  test 'should update all stats for name team finder' do
    validate_stats_update_response('name_team_all_stats', :success, [])
    match_player = NflPlayer.find(22).player_for_game_week(1)
    check_stats(
      match_player,
      STATS_HASH
    )
  end

  test 'should update all stats for name type finder' do
    validate_stats_update_response('name_type_all_stats', :success, [])
    match_player = NflPlayer.find(22).player_for_game_week(1)
    check_stats(
      match_player,
      STATS_HASH
    )
  end

  test 'should update all stats for name team type finder' do
    validate_stats_update_response('name_team_type_all_stats', :success, [])
    match_player = NflPlayer.find(22).player_for_game_week(1)
    check_stats(
      match_player,
      STATS_HASH
    )
  end

  test 'should update the points on updating the stats' do
    validate_stats_update_response('name_team_type_all_stats', :success, [])
    match_player = NflPlayer.find(22).player_for_game_week(1)
    assert_operator match_player.points, :>, 0
  end
end
