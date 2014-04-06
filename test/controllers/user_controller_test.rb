require 'test_helper'

class UserControllerTest < ActionController::TestCase
  # Future tests: Successful auth, correct response, appropriate message displayed
  default_id = 1

  # CREATE
  test 'create redirects to show' do
    post :create, user_name: 'Dummy User Name', team_name: 'Dummy Team Name'
    assert_redirected_to controller: :user, action: :show
  end

  test 'should create new user' do
    new_name = 'John Doriando'
    team_name = 'I love Stafford'

    post :create, user_name: new_name, team_name: team_name

    assert_equal new_name, User.last.name, "Error user wasn't created by controller method!"
  end

  test 'should fail to create new user with null name' do
    nullname = ''

    post :create, user_name: nullname, team_name: 'Dummy Team Name'
    assert_response(:unprocessable_entity)
  end

  test 'should fail to create new user with null team name' do
    nullname = ''

    post :create, user_name: 'Dummy User', team_name: nullname
    assert_response(:unprocessable_entity)
  end

  test 'should fail to create new user without team name' do
    post :create, user_name: 'Dummy User'
    assert_response(:unprocessable_entity)
  end

  test 'should fail to create new user without a user name' do
    post :create, team_name: 'Dummy Team Name'
    assert_response(:unprocessable_entity)
  end

  # DELETE
  test 'delete redirects to show' do
    delete :delete, id: 1
    assert_redirected_to controller: :user, action: :show
  end

  test 'should delete user' do
    delete :delete, id: default_id
    assert_raise ActiveRecord::RecordNotFound do
      User.find(default_id)
    end
  end

  test 'should fail to delete imaginary user' do
    delete :delete, id: 50
    assert_response(:not_found)
  end

  test "can't delete a user without an id" do
    delete :delete
    assert_response(:unprocessable_entity)
  end

  # READ/SHOW
  test 'should get show with no id' do
    can_view_action(:show)
  end

  test 'should get show template with no id' do
    can_view_template(:show)
  end

  test 'should get show layout with no id' do
    can_view_layout(:show, 'layouts/application')
  end

  test 'should get list of users' do
    can_get_entity_list(:show, :users, 'users')
  end

  test 'should see user object from show page is not nil' do
    can_see_entity_obj_not_nil(:show, :users, 'User')
  end

  test 'should see user object from view page has two users' do
    can_see_entity_obj_num_is(:show, :users, 3, 'user')
  end

  test 'should see user object from view page first entry is Mike Sharwood' do
    can_see_entity_row_index_eq(:show, :users, 0, 'Mike Sharwood', 'user')
  end

  test 'should see user object from view page second entry is Imran Wright' do
    can_see_entity_row_index_eq(:show, :users, 1, 'Imran Wright', 'user')
  end

  # UPDATE
  test 'update redirects to show' do
    post :update, id: 1, team_name: 'Changed Team Name'
    assert_redirected_to controller: :user, action: :show
  end

  test 'should edit user' do
    can_edit_entity_obj_name(:update, { id: 1, user_name: 'Timothy Perkins' }, User, 'Mike Sharwood', 'user')
  end

  test 'should fail to edit non-existent user' do
    fail_edit_fake_entity_row_obj(:update, { id: 5, user_name: 'Biggity Boo' }, 'user')
  end

  test 'should edit team name' do
    can_edit_entity_obj_team_name(:update, { id: 1, team_name: 'Changed Team Name' }, User, "Mike's Picks", 'user')
  end

  test "can't edit user with no id" do
    post :update
    assert_response :unprocessable_entity
  end

  test "can't edit user without something to update" do
    post :update, id: 1
    assert_response :unprocessable_entity
  end
end
