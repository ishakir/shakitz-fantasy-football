# -*- encoding : utf-8 -*-
require 'test_helper'

class FixturesControllerTest < ActionController::TestCase
  test "generate requires zero parameters" do
    Fixture.delete_all
    get :generate
    assert_response :success
  end

  test "generate creates the same number of fixtures for everyone" do
    Fixture.delete_all

    get :generate
    user1_no_opponents = User.find(1).opponents.length

    assert_equal user1_no_opponents, User.find(2).opponents.length
    assert_equal user1_no_opponents, User.find(3).opponents.length
  end

  test "Every team is played the same number of times" do
    Fixture.delete_all

    get :generate
    user1_opponents = User.find(1).opponents

    fixtures_v_user2 = Array.new
    fixtures_v_user3 = Array.new

    user1_opponents.each do |opponent|
      if opponent.user.id == 2
        fixtures_v_user2.push opponent
      elsif opponent.user.id == 3
        fixtures_v_user3.push opponent
      end
    end

    assert_equal fixtures_v_user2.size, fixtures_v_user3.size
  end

  test "should generate the correct number of fixtures with 8 users" do
    validate_correct_no_fixtures_generated(8)
  end

  test "should generate the correct number of fixtures with 7 users" do
    validate_correct_no_fixtures_generated(7)
  end

  test "should generate the correct number of fixtures with 6 users" do
    validate_correct_no_fixtures_generated(6)
  end

  test "should generate the correct number of fixtures with 5 users" do
    validate_correct_no_fixtures_generated(5)
  end

  test "should generate the correct number of fixtures with 4 users" do
    validate_correct_no_fixtures_generated(4)
  end

  test "should generate the correct number of fixtures with 3 users" do
    validate_correct_no_fixtures_generated(3)
  end

  test "should generate the correct number of fixtures with 2 users" do
    validate_correct_no_fixtures_generated(2)
  end
end
