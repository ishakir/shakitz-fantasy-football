require 'test_helper'

class UserControllerTest < ActionController::TestCase
  #Future tests: Successful auth, correct response, appropriate message displayed
  defaultID = 1
  
  # CREATE
  test "should get create" do
    can_view_action(:create, {:user_name => "Dummy User", :team_name => "Dummy Team Name"})
  end
  
  test "should return correct create template" do
    can_view_template(:create, {:user_name => "Dummy User", :team_name => "Dummy Team Name"})
  end
  
  test "should return correct create layout" do
    can_view_layout(:create, "layouts/application", {:user_name => "Dummy User", :team_name => "Dummy Team Name"})
  end
  
  test "should create new user" do
    new_name = "John Doriando"
    team_name = "I love Stafford"
    can_create_entity_obj(:success, :create, {:user_name => new_name, :team_name => team_name}, "user")
  end
  
  test "should fail to create new user" do
    nullname = ""
    can_create_entity_obj(:error, :create, {:user_name=>""}, "empty user")
  end
  
  # DELETE
 
 test "should get delete" do
    can_view_action(:delete, {:id=>defaultID})
  end
  
  test "should return correct delete template" do
    can_view_template(:delete, {:id=>defaultID})
  end
  
  test "should return correct delete layout" do
    can_view_layout(:delete, "layouts/application", {:id=>defaultID})
  end
  
  test "should delete user" do
    can_del_ent_obj(:delete, {:id=>defaultID})
  end
  
  test "should fail to delete imaginary user" do
    fail_del_ent_obj(:delete, {:id=>5}, "user")
  end
  
  # READ/SHOW
  
  test "should get show with no id" do
    can_view_action(:show)
  end
  
  test "should return correct show template with no id" do
   can_view_template(:show) 
  end
  
  test "should return correct show layout with no id" do
    can_view_layout(:show, "layouts/application")
  end
  
  test "should get show" do
    can_view_action(:show, {:id=>defaultID})
  end
  
  test "should return correct show template" do
    can_view_template(:show, {:id=>defaultID})
  end
  
  test "should return correct show layout" do
    can_view_layout(:show, "layouts/application", {:id=>defaultID})
  end
  
  test "should get list of users" do
    can_get_entity_list(:show, :users, "users")
  end
  
  test "should show user Mike Sharwood" do
    can_get_entity_row_name(:show, {:id=>defaultID}, :user, "Mike Sharwood")
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
    can_view_action(:update, {:id=>defaultID})
  end
  
  test "should return correct update template" do
    can_view_template(:update, {:id=>defaultID})
  end
  
  test "should return correct update layout" do
    can_view_layout(:update, "layouts/application", {:id=>defaultID})
  end
  
  test "should edit user" do
    can_edit_entity_obj_name(:update, {:id => 1, :name => "Timothy Perkins"}, User, "Mike Sharwood", "user")
  end
  
  test "should fail to edit non-existent user" do
    fail_edit_fake_entity_row_obj(:update, {:id => 5, :name => "Biggity Boo"}, "user")
  end
  
  test "should edit team name" do
    can_edit_entity_obj_team_name(:update, {:id => 1, :team_name => "Changed Team Name"}, User, "Mike's Picks", "user")
  end

end
