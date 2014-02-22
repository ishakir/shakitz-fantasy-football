require 'test_helper'

class UserControllerTest < ActionController::TestCase
  #Future tests: Successful auth, correct response, appropriate message displayed
  defaultID = 1
  
  test "should get viewall" do
    can_view_action(:viewall)
  end
  
  test "should return correct viewall template" do
   can_view_template(:viewall) 
  end
  
  test "should return correct viewall layout" do
    can_view_layout(:viewall, "layouts/application")
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
    assert false
  end
  
  test "should show user Mike Sharwood" do
    get :show, {:id=>1} #:id=>1
    mikeUser = assigns(:user)    
    assert_equal mikeUser.name, "Mike Sharwood"
  end
  
  test "should create new user" do
    assert false
  end

  test "should edit new user" do
    assert false
  end
  
  test "should update new user" do
    assert false
  end
  
  test "should delete new user" do
    assert false
  end
  
  test "should see user object from view page is not nil" do
    get :viewall
    assert_not_nil assigns(:users)
  end
  
  test "should see user object from view page has two users" do
    get :viewall
    users = assigns(:users)
    assert_equal users.length, 2
  end
  
  test "should see user object from view page first entry is Mike Sharwood" do
    get :viewall
    mikeUser = assigns(:users)[0]
    assert_equal mikeUser.name, "Mike Sharwood"
  end
  
  test "should see user object from view page second entry is Imran Wright" do
    get :viewall
    imranUser = assigns(:users)[1]
    assert_equal imranUser.name, "Imran Wright"
  end

end
