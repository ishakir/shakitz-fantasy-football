require 'test_helper'

class FinalControllerTest < ActionController::TestCase
  test 'should get show' do
    get :show
    assert_response :success
  end
end
