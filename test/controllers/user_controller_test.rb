require 'test_helper'

class UserControllerTest < ActionController::TestCase
  #Future tests: Successful auth, correct response, appropriate message displayed
  defaultID = 1
  
  # CREATE
  test "should get create" do
    can_view_action(:create)
  end
  
  test "should return correct create template" do
    can_view_template(:create)
  end
  
  test "should return correct create layout" do
    can_view_layout(:create, "layouts/application")
  end
  
  test "should create new user" do
    newname = "John Doriando"
    post :create, {:username => newname}
    assert User.exists?(name: newname), "Failed to create new user"
  end
  
  test "should fail to create new user" do
    nullname = ""
    response = post :create, {:username => nullname}
    puts(response)
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
  
  test "should delete new user" do
    post :delete, {:id=>defaultID}
    assert_raise ActiveRecord::RecordNotFound do
       User.find(defaultID)
     end
  end
  
  # READ/SHOW
  
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
    get :show
    users = assigns(:users)
    assert users.length > 1, "One or less users were listed"
  end
  
  test "should show user Mike Sharwood" do
    get :show, {:id=>defaultID} #:id=>1
    mikeUser = assigns(:user)    
    assert_equal mikeUser.name, "Mike Sharwood", "Failed to show user Mike Sharwood"
  end
  
  test "should see user object from show page is not nil" do
    get :show
    assert_not_nil assigns(:users), "User object from view page is nil"
  end
  
  test "should see user object from view page has two users" do
    get :show
    users = assigns(:users)
    assert_equal users.length, 2, "Incorrect number of user objects shown"
  end
  
  test "should see user object from view page first entry is Mike Sharwood" do
    get :show
    mikeUser = assigns(:users)[0]
    assert_equal mikeUser.name, "Mike Sharwood", "First user object entry on view page is not Mike Sharwood"
  end
  
  test "should see user object from view page second entry is Imran Wright" do
    get :show
    imranUser = assigns(:users)[1]
    assert_equal imranUser.name, "Imran Wright", "Second user object entry on view page is not Imran Wright"
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
    mikeUser = User.find(1).name
    post :update, {:id => 1, :name => "Timothy Perkins"}
    assert mikeUser != User.find(1).name, "Failed to update user Mike Sharwood"
  end
end
