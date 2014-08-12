# -*- encoding : utf-8 -*-
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  self.use_instantiated_fixtures = true

  # Helper constants
  NUMBER_OF_NFL_PLAYERS = 19
  NUMBER_OF_UNPICKED_NFL_PLAYERS = 2
  NUMBER_OF_PLAYING = 10
  NUMBER_OF_BENCHED = 8

  NUMBER_OF_USERS = 8

  LAST_NFL_PLAYER_NAME_IN_FIXTURES = 'player_17'
  MATCH_PLAYER_ONE_POINTS = 101
  MATCH_PLAYER_TWO_POINTS = 19
  GWT_STAFFORD_PICKS_POINTS = MATCH_PLAYER_ONE_POINTS * 10
  GWT_TWO_POINTS = MATCH_PLAYER_TWO_POINTS * 10
  USER_ONE_POINTS = GWT_STAFFORD_PICKS_POINTS + GWT_TWO_POINTS

  USER_TWO_NO_GWTS = 17

  ROSTER_SIZE = 18

  # Add more helper methods to be used by all tests here...
  def get_assigns(action, variable, params = nil)
    get action, params
    assigns(variable)
  end

  def assert_assigns_not_nil(action, variable, params = nil, message = nil)
    get action, params
    assert_not_nil assigns(variable), message
  end

  def can_view_action(action, params = nil)
    get action, params
    assert_response :success
  end

  def can_view_template(action, params = nil)
    get action, params
    assert_template action
  end

  def can_view_layout(action, layout, params = nil)
    get action, params
    assert_template layout: layout
  end

  def can_get_entity_list(action, ent_obj, obj_name)
    entity_obj = get_assigns(action, ent_obj)
    assert entity_obj.length > 1, "One or less #{obj_name} were listed"
  end

  def can_get_entity_row_name(action, params, ent_obj, obj_name)
    row_obj = get_assigns(action, ent_obj, params)
    assert_equal row_obj.name, obj_name, "Failed to show #{obj_name}"
  end

  def can_see_entity_obj_not_nil(action, ent_obj, obj_name)
    assert_not_nil get_assigns(action, ent_obj), "#{obj_name} object from view page is nil"
  end

  def can_see_entity_obj_num_is(action, ent_obj, num, obj_name)
    obj = get_assigns(action, ent_obj)
    assert_equal obj.length, num, "Incorrect number of #{obj_name} objects shown"
  end

  def can_see_entity_row_index_eq(action, ent_obj, i, exp_row_name, obj_name)
    assert_equal get_assigns(action, ent_obj)[i].name, exp_row_name, "#{i} #{obj_name} object entry on view page is not" + exp_row_name
  end

  def can_edit_entity_obj_team_name(action, params, ent_obj, exp_row_name, obj_name)
    pre_edit_obj = ent_obj.find(params[:user_id])
    post action, params
    row_obj = ent_obj.find(params[:user_id])
    assert_not_equal pre_edit_obj.team_name, row_obj.team_name, "Failed to update #{obj_name} #{exp_row_name}"
  end

  def fail_edit_fake_entity_row_obj(action, params, obj_name)
    post action, params
    assert_response(:missing, "Managed to update non-existent #{obj_name}")
  end

  def delete_last_users(number)
    number.times do |n|
      User.find(8 - n).destroy!
    end
  end

  def validate_fixture_vs_spread_is_even(no_users)
    Fixture.delete_all
    delete_last_users(NUMBER_OF_USERS - no_users)

    get :generate

    all_users = User.all
    fixtures_array = Array.new(all_users.size) do
      Array.new(all_users.size, 0)
    end

    all_users.each do |user|
      user.opponents.each do |opponent|
        fixtures_array[user.id - 1][opponent.user.id - 1] += 1
      end
    end

    no_of_1_vs_2 = fixtures_array[0][1] + fixtures_array[1][0]
    0.upto(fixtures_array.size - 1) do |n|
      (n + 1).upto(fixtures_array.size - 1) do |m|
        assert_equal no_of_1_vs_2, fixtures_array[n][m] + fixtures_array[m][n]
      end
    end
  end

  def validate_everyone_plays_same_no_games(no_users)
    Fixture.delete_all
    delete_last_users(NUMBER_OF_USERS - no_users)

    get :generate

    user_1_no_fixtures = User.find(1).opponents.size

    # Check users no 2 - no_users for same number of games
    (no_users - 1).times do |n|
      assert_equal user_1_no_fixtures, User.find(2 + n).opponents.size
    end
  end

  def validate_correct_no_fixtures_generated(no_users)
    Fixture.delete_all
    delete_last_users(NUMBER_OF_USERS - no_users)

    get :generate

    # If odd, one team doesn't play per week
    fixtures_per_gw = no_users.even? ? no_users / 2 : (no_users - 1) / 2
    game_weeks_with_fixtures = no_users.even? ? 17 - (17 % (no_users - 1)) : 17 - (17 % no_users)

    no_fixtures = fixtures_per_gw * game_weeks_with_fixtures

    assert_equal no_fixtures, Fixture.all.size
  end

  def parse_data_file(directory, filename)
    data = IO.read("test/data/#{directory}/#{filename}.json")
    JSON.parse(data)
  end

  def parse_nfl_player_data_file(filename)
    parse_data_file('nfl_player', filename)
  end

  def validate_stats_update_response(filename, expected_response, expected_messages)
    # Parse the json in the data file specified
    json = parse_nfl_player_data_file(filename)

    # Make the post request and validate the response
    post :update_stats, format: :json, game_week: 1, player: json
    assert_response expected_response

    # Parse the response body
    response_body = JSON.parse(response.body)

    # Check that the number and type of messages are correct
    message_ids = response_body['messages'].map do |full_message_desc|
      full_message_desc['id']
    end
    assert_equal expected_messages.size, response_body['messages'].size
    expected_messages.each do |id|
      assert message_ids.include?(id), "#{id} not found in #{message_ids}"
    end
  end

  def check_stats(match_player, stats)
    stats.keys.each do |key|
      assert_equal stats[key], match_player.read_attribute(key), "Stat #{key} is incorrect"
    end
  end

  def json_response
    ActiveSupport::JSON.decode @response.body
  end
end
