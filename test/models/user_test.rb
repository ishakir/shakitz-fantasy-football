require 'test_helper'

class UserTest < ActiveSupport::TestCase
  season_length = 17

  test 'can request user name' do
    user = User.find(1)
    assert_respond_to(user, :name)
  end

  test 'can request team name' do
    user = User.find(1)
    assert_respond_to(user, :team_name)
  end

  test 'can add user' do
    User.create!(name: 'Test User', team_name: 'Test Team Name')
    last_entry = User.last
    assert_equal 'Test User', last_entry.name
  end

  test 'can find user' do
    user = User.where(name: 'Imran Wright').first
    assert_equal 'Imran Wright', user.name
  end

  test "can find user's team name" do
    user = User.where(name: 'Imran Wright').first
    assert_equal user.team_name, 'Destroyers'
  end

  test 'can not save without a team name' do
    user = User.new
    user.name = 'Andy Neilson'
    assert !user.save
  end

  test 'can not save without name' do
    user = User.new
    assert !user.save
  end

  test 'can not add user with empty name' do
    user = User.new
    user.name = ''
    assert !user.save
  end

  test 'can update user name' do
    new_name = 'Mike Spitz'
    user = User.find(1) # Mike Sharwood
    user.update!(name: new_name)
    assert_equal new_name, user.name
  end

  test 'can delete entry' do
    User.find(2).destroy # Imran
    assert_raise ActiveRecord::RecordNotFound do
      User.find(2)
    end
  end

  test 'User one has the correct number of gameweek teams' do
    user = User.find(1)
    assert_equal user.game_week_teams.length, 17, 'Incorrect number of gameweek teams for user one'
  end

  test 'User two has the correct number of gameweek teams' do
    user = User.find(2)
    assert_equal user.game_week_teams.length, 1, 'Incorrect number of gameweek teams for user two'
  end

  test 'We delete a user and all his gameweek teams are deleted' do
    user = User.find(1)
    user.destroy

    assertion = true
    season_length.times do |n|
      begin
        GameWeekTeam.find(n)
        assertion &&= false
      rescue ActiveRecord::RecordNotFound
        assertion &&= true
      end
    end

    assert assertion, 'ERROR: Found some of the gameweek teams, even when we deleted their user'
  end

  test 'Can get users total points' do
    user = User.find(1)
    assert_equal USER_ONE_POINTS, user.points, 'Failed to get total team points'
  end

  test 'username must be unique' do
    user = User.new
    user.name = 'Imran Wright'
    assert !user.save
  end
end
