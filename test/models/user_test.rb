require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup #not sure if this can be called something else
    #@user = user.new
  end
  
  test "can request user name" do
    user = User.find(1)
    assert_respond_to(user, :name)
  end
  test "can add user" do
    User.create("name" => "Test User")
    lastEntry = User.last
    assert_equal "Test User", lastEntry.name
  end
  
  test "can find user" do
    user = User.where(:name => "Imran Wright").first
    assert_equal "Imran Wright", user.name
  end
  
  test "can not save without name" do
    user = User.new
    assert !user.save
  end
  
  test "can not add user with empty name" do
    user = User.new
    user.name = ""
    assert !user.save
  end
  
  test "can update user name" do
    new_name = "Mike Spitz"
    user = User.find(1) #Mike Sharwood
    user.update("name" => new_name)
    assert_equal new_name, user.name
  end
  
  test "can delete entry" do
    User.find(2).destroy#Imran
    assert_raise ActiveRecord::RecordNotFound do
       User.find(2)
     end
  end
  
end
