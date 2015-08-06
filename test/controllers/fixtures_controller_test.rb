# -*- encoding : utf-8 -*-
require 'test_helper'

class FixturesControllerTest < ActionController::TestCase
  # This is a work around for a rails bug, it appears that rails won't
  # create it for the first test :/
  def setup
    @controller = FixturesController.new
  end

  test 'should fail to return json with no game week' do
    get :fixtures_for_week
    assert_response :unprocessable_entity
  end

  test 'should return empty json with invalid game week' do
    get :fixtures_for_week, game_week: 20
    parsed_body = JSON.parse(response.body)
    assert parsed_body.empty?
  end

  test 'should return valid json for valid game week' do
    get :fixtures_for_week, game_week: 1
    parsed_body = JSON.parse(response.body)[0]
    assert_equal("Stafford's Picks", parsed_body['home_name'])
    assert_equal('Destroyers', parsed_body['away_name'])
  end
end
