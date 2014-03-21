require 'test_helper'

class MatchPlayerControllerTest < ActionController::TestCase
  test "should get rushing" do
    can_view_action :rushing
  end

  test "should get passing" do
    can_view_action :passing
  end

  test "should get defense" do
     can_view_action :defense
  end

  test "should get kicker" do
    can_view_action :kicker
  end

  test "should get show" do
    can_view_action :show
  end
  
  test "should get rushing template" do
    can_view_template :rushing
  end

  test "should get passing template" do
    can_view_template :passing
  end

  test "should get defense template" do
     can_view_template :defense
  end

  test "should get kicker template" do
    can_view_template :kicker
  end

  test "should get show template" do
    can_view_template :show
  end
  
  test "should get rushing layout" do
    can_view_layout :rushing, "layouts/application"
  end

  test "should get passing layout" do
    can_view_layout :passing, "layouts/application"
  end

  test "should get defense layout" do
     can_view_layout :defense, "layouts/application"
  end

  test "should get kicker layout" do
    can_view_layout :kicker, "layouts/application"
  end

  test "should get show layout" do
    can_view_layout :show, "layouts/application"
  end

end
