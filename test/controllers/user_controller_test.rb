require 'test_helper'

class UserControllerTest < ActionController::TestCase
  #Future tests: Successful auth, correct response, appropriate message displayed
  defaultID = 1
  
  # CREATE
  test "should get create" do
    can_view_action(:create, {:user_name => "Dummy User", :team_name => "Dummy Team Name"})
  end
  
  test "should get create template" do
    can_view_template(:create, {:user_name => "Dummy User", :team_name => "Dummy Team Name"})
  end
  
  test "should get create layout" do
    can_view_layout(:create, "layouts/application", {:user_name => "Dummy User", :team_name => "Dummy Team Name"})
  end
  
  test "should create new user" do
    new_name = "John Doriando"
    team_name = "I love Stafford"
    
    post :create, {:user_name => new_name, :team_name => team_name}
    assert_response(:success)
    
    assert_equal new_name, User.last.name, "Error user wasn't created by controller method!" 
  end
  
  test "should fail to create new user with null name" do
    nullname = ""
    
    post :create, {:user_name => nullname, :team_name => "Dummy Team Name"}
    assert_response(:unprocessable_entity)
  end
  
  test "should fail to create new user with null team name" do
    nullname = ""
    
    post :create, {:user_name => "Dummy User", :team_name => nullname}
    assert_response(:unprocessable_entity)
  end
  
  test "should fail to create new user without team name" do
    post :create, {:user_name => "Dummy User"}
    assert_response(:unprocessable_entity)
  end
  
  test "should fail to create new user without a user name" do
    post :create, {:team_name => "Dummy Team Name"}
    assert_response(:unprocessable_entity)
  end
  
  # DELETE
 
 test "should get delete" do
    can_view_action(:delete, {:id => defaultID})
  end
  
  test "should get delete template" do
    can_view_template(:delete, {:id => defaultID})
  end
  
  test "should get delete layout" do
    can_view_layout(:delete, "layouts/application", {:id => defaultID})
  end
  
  test "should delete user" do
    delete :delete, {:id => defaultID}
    assert_raise ActiveRecord::RecordNotFound do
       User.find(defaultID)
    end
  end
  
  test "should fail to delete imaginary user" do
    delete :delete, {:id => 50}
    assert_response(:not_found)
  end
  
  test "can't delete a user without an id" do
    delete :delete
    assert_response(:unprocessable_entity)
  end
  
  # READ/SHOW
  
  test "should get show with no id" do
    can_view_action(:show)
  end
  
  test "should get show template with no id" do
   can_view_template(:show) 
  end
  
  test "should get show layout with no id" do
    can_view_layout(:show, "layouts/application")
  end
  
  test "should get show" do
    can_view_action(:show, {:id => defaultID})
  end
  
  test "should get show template" do
    can_view_template(:show, {:id => defaultID})
  end
  
  test "should get show layout" do
    can_view_layout(:show, "layouts/application", {:id => defaultID})
  end
  
  test "should get list of users" do
    can_get_entity_list(:show, :users, "users")
  end
  
  test "should show user Mike Sharwood" do
    can_get_entity_row_name(:show, {:id => defaultID}, :user, "Mike Sharwood")
  end
  
  test "should see user object from show page is not nil" do
    can_see_entity_obj_not_nil(:show, :users, "User")
  end
  
  test "should see user object from view page has two users" do
    can_see_entity_obj_num_is(:show, :users, 2, "user")
  end
  
  test "should see user object from view page first entry is Mike Sharwood" do
    can_see_entity_row_index_eq(:show, :users, 0, "Mike Sharwood", "user")
  end
  
  test "should see user object from view page second entry is Imran Wright" do
    can_see_entity_row_index_eq(:show, :users, 1, "Imran Wright", "user")
  end
  
  # UPDATE

  test "should get update" do
    can_view_action(:update, {:id => defaultID, :user_name => "Dummy User Name"})
  end
  
  test "should get update template" do
    can_view_template(:update, {:id => defaultID, :user_name => "Dummy User Name"})
  end
  
  test "should get update layout" do
    can_view_layout(:update, "layouts/application", {:id => defaultID, :user_name => "Dummy User Name"})
  end
  
  test "should edit user" do
    can_edit_entity_obj_name(:update, {:id => 1, :user_name => "Timothy Perkins"}, User, "Mike Sharwood", "user")
  end
  
  test "should fail to edit non-existent user" do
    fail_edit_fake_entity_row_obj(:update, {:id => 5, :user_name => "Biggity Boo"}, "user")
  end
  
  test "should edit team name" do
    can_edit_entity_obj_team_name(:update, {:id => 1, :team_name => "Changed Team Name"}, User, "Mike's Picks", "user")
  end
  
  test "can't edit user with no id" do
    post :update
    assert_response :unprocessable_entity
  end
  
  test "can't edit user without something to update" do
    post :update, {:id => 1}
    assert_response :unprocessable_entity
  end

end
