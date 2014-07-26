# -*- encoding : utf-8 -*-
require 'test_helper'

class UserControllerTest < ActionController::TestCase
  # Future tests: Successful auth, correct response, appropriate message displayed
  default_id = 1

  # CREATE
  test 'create redirects to show' do
    post :create, "user" => { name: 'Dummy User Name', team_name: 'Dummy Team Name', password: 'dummyPassword', password_confirmation: 'dummyPassword' }
    assert_redirected_to controller: :user, action: :home, notice: "Signed up!"
  end

  test 'should create new user' do
    new_name = 'John Doriando'
    team = 'I love Stafford'
    pw = 'Lions4Life'

    post :create, "user" => { name: new_name, team_name: team, password: pw, password_confirmation: pw }

    assert_equal new_name, User.last.name, "Error user wasn't created by controller method!"
  end

  test 'should fail to create new user with null name' do
    nullname = ''

    post :create, "user" => { name: nullname, team_name: 'Dummy Team Name' }
    assert_response(:unprocessable_entity)
  end

  test 'should fail to create new user with null team name' do
    nullname = ''

    post :create, "user" => { user_name: 'Dummy User', team_name: nullname }
    assert_response(:unprocessable_entity)
  end

  test 'should fail to create new user without team name' do
    post :create, "user" => { user_name: 'Dummy User' }
    assert_response(:unprocessable_entity)
  end

  test 'should fail to create new user without a user name' do
    post :create, "user" => { team_name: 'Dummy Team Name' }
    assert_response(:unprocessable_entity)
  end

  # DELETE
  test 'delete redirects to show' do
    delete :delete, user_id: 1
    assert_redirected_to controller: :user, action: :home
  end

  test 'should delete user' do
    delete :delete, user_id: default_id
    assert_raise ActiveRecord::RecordNotFound do
      User.find(default_id)
    end
  end

  test 'should fail to delete imaginary user' do
    delete :delete, user_id: 50
    assert_response(:not_found)
  end

  test "can't delete a user without an id" do
    delete :delete
    assert_response(:unprocessable_entity)
  end

  # Show all users
  test 'should get show with no id' do
    can_view_action(:home)
  end

  test 'should get show template with no id' do
    can_view_template(:home)
  end

  test 'should get show layout with no id' do
    can_view_layout(:home, 'layouts/application')
  end

  test 'should get list of users' do
    can_get_entity_list(:home, :users, 'users')
  end

  test 'should see user object from show page is not nil' do
    can_see_entity_obj_not_nil(:home, :users, 'User')
  end

  test 'should see user object from view page has two users' do
    can_see_entity_obj_num_is(:home, :users, NUMBER_OF_USERS, 'user')
  end

  test 'should see user object from view page first entry is Mike Sharwood' do
    can_see_entity_row_index_eq(:home, :users, 0, 'Mike Sharwood', 'user')
  end

  test 'should see user object from view page second entry is Imran Wright' do
    can_see_entity_row_index_eq(:home, :users, 1, 'Imran Wright', 'user')
  end

  # Show user breakdown
  test 'should reject the request to load show if user_id is invalid' do
    get :show, user_id: 10
    assert_response :not_found
  end

  test 'should accept the request if user_id is valid' do
    get :show, user_id: 1
    assert_response :success
  end

  test 'should show correct template if user_id is valid' do
    get :show, user_id: 1
    assert_template :show
  end

  test 'should show correct layout if user_id is valid' do
    get :show, user_id: 1
    assert_template layout: 'layouts/application'
  end

  test 'should put user entity into a variable called @user' do
    user = get_assigns :show, :user, user_id: 1
    assert_kind_of User, user
  end

  test '@user has the id requested' do
    user = get_assigns :show, :user, user_id: 1
    assert_equal 1, user.id
  end

  # Show gameweek breakdown
  test 'should reject the request to get gameweekteam if user_id is invalid' do
    get :game_week_team, user_id: 10, game_week: 1
    assert_response :not_found
  end

  test 'should reject the request if game_week is invalid' do
    get :game_week_team, user_id: 1, game_week: 50
    assert_response :not_found
  end

  test 'should accept the request if both parameters are valid' do
    get :game_week_team, user_id: 1, game_week: 1
    assert_response :success
  end

  test 'should put the user into a variable called @user' do
    user = get_assigns :game_week_team, :user, user_id: 1, game_week: 1
    assert_kind_of User, user
  end

  test 'should get a user with the correct id' do
    user = get_assigns :game_week_team, :user, user_id: 1, game_week: 1
    assert_equal 1, user.id
  end

  test 'should put the game week team into a variable called @game_week_team' do
    game_week_team = get_assigns :game_week_team, :game_week_team, user_id: 1, game_week: 1
    assert_kind_of GameWeekTeam, game_week_team
  end

  test 'should get a game week team with the correct game week number' do
    game_week_team = get_assigns :game_week_team, :game_week_team, user_id: 1, game_week: 1
    assert_equal 1, game_week_team.game_week.number
  end

  test 'should get the game_week_team from the correct user' do
    game_week_team = get_assigns :game_week_team, :game_week_team, user_id: 1, game_week: 1
    assert_equal 1, game_week_team.user.id
  end

  # UPDATE
  test 'update redirects to show' do
    post :update, user_id: 1, team_name: 'Changed Team Name'
    assert_redirected_to controller: :user, action: :home
  end

  test 'should edit user' do
    user_id = 1

    pre_edit_user = User.find(user_id)
    post :update, user_id: user_id, name: 'Timothy Perkins'

    post_edit_user = User.find(user_id)
    assert_not_equal pre_edit_user.name, post_edit_user.name, 'Failed to update User'
  end

  test 'should fail to edit non-existent user' do
    fail_edit_fake_entity_row_obj(:update, { user_id: 50, name: 'Biggity Boo' }, 'user')
  end

  test 'should edit team name' do
    can_edit_entity_obj_team_name(:update, { user_id: 1, team_name: 'Changed Team Name' }, User, "Mike's Picks", 'user')
  end

  test "can't edit user with no id" do
    post :update
    assert_response :unprocessable_entity
  end

  test "can't edit user without something to update" do
    post :update, user_id: 1
    assert_response :unprocessable_entity
  end

  # Swap players
  test "can't swap players without playing_player_id" do
    post :swap_players, user_id: 1, game_week: 1, benched_player_id: 11
    assert_response :unprocessable_entity
  end

  test "can't swap players without benched_player_id" do
    post :swap_players, user_id: 1, game_week: 1, playing_player_id: 1
    assert_response :unprocessable_entity
  end

  test "can't swap players if user_id doesn't exist" do
    post :swap_players, user_id: 5000, game_week: 1, playing_player_id: 1, benched_player_id: 11
    assert_response :not_found
  end

  test "can't swap players if game_week doesn't exist" do
    post :swap_players, user_id: 1, game_week: 50, playing_player_id: 1, benched_player_id: 11
  end

  test "can't swap players if playing_player doesn't exist" do
    post :swap_players, user_id: 1, game_week: 1, playing_player_id: 1000, benched_player_id: 11
    assert_response :not_found
  end

  test "can't swap players if benched_player doesn't exist" do
    post :swap_players, user_id: 1, game_week: 1, playing_player_id: 1, benched_player_id: 1000
    assert_response :not_found
  end

  test "can't swap players if both playing" do
    post :swap_players, user_id: 1, game_week: 1, playing_player_id: 1, benched_player_id: 2
    assert_response :unprocessable_entity
  end

  test "can't swap players if both benched" do
    post :swap_players, user_id: 1, game_week: 1, playing_player_id: 11, benched_player_id: 12
    assert_response :unprocessable_entity
  end

  test "we get a success response if parameters are correct" do
    post :swap_players, user_id: 1, game_week: 1, playing_player_id: 1, benched_player_id: 11
    assert_response :success
  end

  test "playing_player is benched after swapping" do
    post :swap_players, user_id: 1, game_week: 1, playing_player_id: 1, benched_player_id: 11
    gwtps = GameWeekTeamPlayer.where(match_player_id: 1, game_week_team_id: 1)
    assert_equal 1, gwtps.size
    player = gwtps.first
    assert !player.playing
  end

  test "benched_player is benched after swapping" do
    post :swap_players, user_id: 1, game_week: 1, playing_player_id: 1, benched_player_id: 11
    gwtps = GameWeekTeamPlayer.where(match_player_id: 11, game_week_team_id: 1)
    assert_equal 1, gwtps.size
    player = gwtps.first
    assert player.playing
  end
end
