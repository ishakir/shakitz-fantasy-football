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
  # Tests for update_stats
  ##################################
  # test "should reject no player attribute" do
  #   post :update_stats, format: :json, game_week: 1
  #   assert_response :unprocessable_entity
  #   parsed_body = JSON.parse(response.body)
  #   assert_equal 1, parsed_body['messages'].size
  #   assert_equal 1, parsed_body['messages'][0]['id']
  # end

  # test "should reject if no id_info" do
  #   validate_stats_update_response('no_identification_info', :unprocessable_entity, [1])
  # end

  # test "should reject if id_info contains no content" do
  #   validate_stats_update_response('no_identification_data', :unprocessable_entity, [1])
  # end

  # test "should reject if only type is supplied" do
  #   validate_stats_update_response('only_type', :unprocessable_entity, [2])
  # end

  # test "should reject is only team is supplied" do
  #   validate_stats_update_response('only_team', :unprocessable_entity, [3])
  # end

  # test "should reject if id is incorrect" do
  #   validate_stats_update_response('invalid_id', :not_found, [11])
  # end

  # test "should reject if name cannot be found" do
  #   validate_stats_update_response('name_doesnt_exist', :not_found, [12])
  # end

  # test "should reject if name / type combination cannot be found" do
  #   validate_stats_update_response('name_type_combo_doesnt_exist', :not_found, [13])
  # end

  # test "should reject if name / team combination cannot be found" do
  #   validate_stats_update_response('name_team_combo_doesnt_exist', :not_found, [14])
  # end

  # test "should reject if team / type combination cannot be found" do
  #   validate_stats_update_response('team_type_combo_doesnt_exist', :not_found, [15])
  # end

  # test "should reject if name / team / type combination cannot be found" do
  #   validate_stats_update_response('name_team_type_combo_doesnt_exist', :not_found, [16])
  # end

  # test "should reject if multiple players have the same name" do
  #   validate_stats_update_response('multiple_players_with_name', :not_found, [21])
  # end

  # test "should reject if multiple players have the same name / type" do
  #   validate_stats_update_response('multiple_players_with_name_type_combo', :not_found, [22])
  # end

  # test "should reject if multiple players have the same name / team" do
  #   validate_stats_update_response('multiple_players_with_name_team_combo', :not_found, [23])
  # end

  # test "should reject if multiple players have the same team / type" do
  #   validate_stats_update_response('multiple_players_with_team_type_combo', :not_found, [24])
  # end

  # test "should reject if multiple players have the same name / team / type" do
  #   validate_stats_update_response('multiple_players_with_name_type_team_combo', :not_found, [25])
  # end
end
