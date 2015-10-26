require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @valid_params = {
      user: 1,
      text: 'Stafford will never be MVP',
      timestamp: Time.zone.now
    }
  end

  test 'cannot add comment with no user' do
    post :create, request: @valid_params.except(:user)
    assert_response :unprocessable_entity
  end

  test 'cannot add comment for a user who does not exist' do
    params = @valid_params
    params[:user] = 99_999
    post :create, request: params
    assert_response :not_found
  end

  test 'cannot add comment with no text' do
    post :create, request: @valid_params.except(:text)
    assert_response :unprocessable_entity
  end

  test 'cannot add comment with no timestamp' do
    post :create, request: @valid_params.except(:timestamp)
    assert_response :unprocessable_entity
  end

  test 'can add a valid comment' do
    post :create, request: @valid_params
    assert_response :success
  end
end
