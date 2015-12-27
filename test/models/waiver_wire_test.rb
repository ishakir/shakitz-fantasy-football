require 'test_helper'

class WaiverWireTest < ActiveSupport::TestCase
  def setup
    @valid_params = {
      user: User.find(8),
      player_out: NflPlayer.find(3),
      player_in: NflPlayer.find(4),
      game_week: GameWeek.find(2),
      incoming_priority: 5,
      status: WaiverWire::STATUS_PENDING
    }
  end

  test 'can add valid waiver wire request' do
    WaiverWire.create!(@valid_params)
    assert_equal User.find(8), WaiverWire.last.user
    assert_equal 5, WaiverWire.last.incoming_priority
  end

  test 'user must be present' do
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(@valid_params.except(:user))
    end
  end

  test 'offered player must be present' do
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(@valid_params.except(:player_out))
    end
  end

  test 'targeted player must be present' do
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(@valid_params.except(:player_in))
    end
  end

  test 'game week must be present' do
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(@valid_params.except(:game_week))
    end
  end

  test 'incoming priority must be present' do
    assert_raise ActiveRecord::RecordInvalid do
      WaiverWire.create!(@valid_params.except(:incoming_priority))
    end
  end

  test "can't add multiple targets under same priority in same round" do
    WaiverWire.create!(@valid_params)
    assert_raise ActiveRecord::RecordInvalid do
      (WaiverWire.create!(@valid_params))
    end
  end

  test 'user can have multiple waiver wire requests' do
    WaiverWire.create!(@valid_params)
    new_params = @valid_params
    new_params[:incoming_priority] = 3
    new_params[:player_out] = NflPlayer.find(5)

    WaiverWire.create!(new_params)
    assert_equal User.find(8), WaiverWire.last.user
    assert_equal 3, WaiverWire.last.incoming_priority
  end

  def order_by_player_in_id(waiver, _game_week)
    waiver.player_in_id
  end

  def order_by_reverse_player_in_id(waiver, _game_week)
    -waiver.player_in_id
  end

  test 'waiver list respects the sorting method provided' do
    waiver_lower_player_in_id = WaiverWire.create!({ user: User.find(1), player_out_id: 1, player_in_id: 6, game_week: GameWeek.find_by(number: 2), incoming_priority: 1, status: WaiverWire::STATUS_PENDING })
    waiver_higher_player_in_id = WaiverWire.create!({ user: User.find(1), player_out_id: 3, player_in_id: 7, game_week: GameWeek.find_by(number: 2), incoming_priority: 2, status: WaiverWire::STATUS_PENDING })

    waiver_list_created_at = WaiverWire.waiver_list(2, method(:order_by_player_in_id))
    assert_equal 2, waiver_list_created_at.length
    assert_equal waiver_lower_player_in_id, waiver_list_created_at[0]

    waiver_list_created_at_reverse = WaiverWire.waiver_list(2, method(:order_by_reverse_player_in_id))
    assert_equal 2, waiver_list_created_at_reverse.length
    assert_equal waiver_higher_player_in_id, waiver_list_created_at_reverse[0]
  end

  # For week 2 user with id 2 has waiver priority
  test 'priority then points comparison works' do
    user_1_priority_2 = WaiverWire.create!({ user: User.find(1), player_out_id: 3, player_in_id: 8, game_week: GameWeek.find_by(number: 2), incoming_priority: 2, status: WaiverWire::STATUS_PENDING })
    user_1_priority_1 = WaiverWire.create!({ user: User.find(1), player_out_id: 1, player_in_id: 6, game_week: GameWeek.find_by(number: 2), incoming_priority: 1, status: WaiverWire::STATUS_PENDING })
    user_2_priority_1 = WaiverWire.create!({ user: User.find(2), player_out_id: 2, player_in_id: 7, game_week: GameWeek.find_by(number: 2), incoming_priority: 1, status: WaiverWire::STATUS_PENDING })

    waiver_list = WaiverWire.waiver_list(2)
    assert_equal 3, waiver_list.length
    assert_equal user_2_priority_1, waiver_list[0]
    assert_equal user_1_priority_1, waiver_list[1]
    assert_equal user_1_priority_2, waiver_list[2]
  end

  # For week 4 user with id 2 should still have priority
  # User 1 has game week team id 4
  # User 2 has game week team id 21

  def assert_accepted(waiver)
    assert_equal WaiverWire::STATUS_ACCEPTED.to_s, WaiverWire.find(waiver.id).status
  end

  def assert_rejected(waiver)
    assert_equal WaiverWire::STATUS_REJECTED.to_s, WaiverWire.find(waiver.id).status
  end

  def assert_in_no_team(nfl_player)
    assert_nil nfl_player.player_for_game_week(4).game_week_team
  end

  def assert_in_team_with_status(user, nfl_player, status)
    match_player = nfl_player.player_for_game_week(4)
    assert_equal user.team_for_game_week(4), match_player.game_week_team
    assert_equal status, match_player.game_week_team_players[0].playing
  end

  test 'simple swap is completed' do
    user = User.find(1)
    out_player = NflPlayer.find(250)
    in_player = NflPlayer.find(251)
    waiver = WaiverWire.create!(user: user, player_out: out_player, player_in: in_player, game_week: GameWeek.find_by(number: 4), incoming_priority: 1, status: WaiverWire::STATUS_PENDING)

    WaiverWire.resolve(4)

    assert_accepted waiver
    assert_in_no_team out_player
    assert_in_team_with_status user, in_player, false
  end

  test 'if two requests are made with the same player out, the incoming priority will determine which swap is done' do
    user = User.find(1)
    out_player = NflPlayer.find(250)
    not_in_player = NflPlayer.find(251)
    actual_in_player = NflPlayer.find(252)

    rejected_waiver = WaiverWire.create!(user: user, player_out: out_player, player_in: not_in_player, game_week: GameWeek.find_by(number: 4), incoming_priority: 2, status: WaiverWire::STATUS_PENDING)
    accepted_waiver = WaiverWire.create!(user: user, player_out: out_player, player_in: actual_in_player, game_week: GameWeek.find_by(number: 4), incoming_priority: 1, status: WaiverWire::STATUS_PENDING)

    WaiverWire.resolve(4)

    assert_accepted accepted_waiver
    assert_rejected rejected_waiver
    assert_in_no_team out_player
    assert_in_no_team not_in_player
    assert_in_team_with_status user, actual_in_player, false
  end

  test 'if two requests are made with the same player in, the incoming priority will determine which swap is done' do
    user = User.find(1)
    actual_out_player = NflPlayer.find(250)
    not_out_player = NflPlayer.find(253)
    in_player = NflPlayer.find(251)

    accepted_waiver = WaiverWire.create!(user: user, player_out: actual_out_player, player_in: in_player, game_week: GameWeek.find_by(number: 4), incoming_priority: 1, status: WaiverWire::STATUS_PENDING)
    rejected_waiver = WaiverWire.create!(user: user, player_out: not_out_player, player_in: in_player, game_week: GameWeek.find_by(number: 4), incoming_priority: 2, status: WaiverWire::STATUS_PENDING)

    WaiverWire.resolve(4)

    assert_accepted accepted_waiver
    assert_rejected rejected_waiver
    assert_in_no_team actual_out_player
    assert_in_team_with_status user, not_out_player, true
    assert_in_team_with_status user, in_player, false
  end

  test 'if both requests are legimite in series, both are executed' do
    user = User.find(1)
    out_player_1 = NflPlayer.find(250)
    out_player_2 = NflPlayer.find(253)
    in_player_1 = NflPlayer.find(251)
    in_player_2 = NflPlayer.find(252)

    waiver_1 = WaiverWire.create!(user: user, player_out: out_player_1, player_in: in_player_1, game_week: GameWeek.find_by(number: 4), incoming_priority: 1, status: WaiverWire::STATUS_PENDING)
    waiver_2 = WaiverWire.create!(user: user, player_out: out_player_2, player_in: in_player_2, game_week: GameWeek.find_by(number: 4), incoming_priority: 2, status: WaiverWire::STATUS_PENDING)

    WaiverWire.resolve(4)

    assert_accepted waiver_1
    assert_accepted waiver_2
    assert_in_no_team out_player_1
    assert_in_no_team out_player_2
    assert_in_team_with_status user, in_player_1, false
    assert_in_team_with_status user, in_player_2, true
  end
end
