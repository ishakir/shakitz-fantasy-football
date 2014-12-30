require 'test_helper'

class WaiverWiresControllerTest < ActionController::TestCase
  def setup
    @valid_params = {
      user: 1,
      player_in: 1,
      player_out: 2,
      game_week: 1,
      incoming_priority: 1
    }
  end

  test 'adding waiver wire request fails without a user' do
    post :add, request: [@valid_params.except(:user)]
    assert_response :unprocessable_entity
  end

  test 'adding waiver wire request fails without an incoming player' do
    post :add, request: [@valid_params.except(:player_in)]
    assert_response :unprocessable_entity
  end

  test 'adding waiver wire request fails without an outgoing player' do
    post :add, request: [@valid_params.except(:player_out)]
    assert_response :unprocessable_entity
  end

  test 'adding waiver wire request fails without a game week' do
    post :add, request: [@valid_params.except(:game_week)]
    assert_response :unprocessable_entity
  end

  test 'adding waiver wire request fails without an incoming priority' do
    post :add, request: [@valid_params.except(:incoming_priority)]
    assert_response :unprocessable_entity
  end

  test 'adding waiver wire request fails if incoming and outgoing ids are same' do
    params = @valid_params
    params[:player_out] = params[:player_in]
    post :add, request: [params]
    assert_response :unprocessable_entity
  end

  test "adding waiver wire request fails if gameweek isn't current gameweek" do
    params = @valid_params
    params[:game_week] = 25
    post :add, request: [params]
    assert_response :unprocessable_entity
  end

  test 'adding valid waiver wire request works' do
    post :add, request: [@valid_params]
    assert_response :success
  end

  test 'adding waiver wire request fails without a valid user' do
    params = @valid_params
    params[:user] = 35
    post :add, request: [params]
    assert_response :not_found
  end

  test 'adding waiver wire request fails without a valid incoming player' do
    params = @valid_params
    params[:player_in] = 90
    post :add, request: [params]
    assert_response :not_found
  end

  test 'adding waiver wire request fails without a valid outgoing player' do
    params = @valid_params
    params[:player_out] = 90
    post :add, request: [params]
    assert_response :not_found
  end

  test 'adding waiver wire request fails with an invalid incoming priority' do
    params = @valid_params
    params[:incoming_priority] = 0
    post :add, request: [params]
    assert_response :unprocessable_entity
  end

  test 'adding multiple waiver wire requests succeeds' do
    second_request = @valid_params
    second_request[:incoming_priority] = 2
    second_request[:player_out] = 3
    post :add, request: [@valid_params, second_request]
    assert_response :success
  end

  test 'adding multiple waiver wire requests with conflicting priorities fails' do
    original_count = WaiverWire.all.length
    second_request = @valid_params
    post :add, request: [@valid_params, second_request]
    assert_equal original_count + 1, WaiverWire.all.length, 'Incorrect number of waiver wire requests were processed'
  end
end
