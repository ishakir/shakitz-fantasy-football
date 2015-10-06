require 'test_helper'

class WaiverWireTest < ActiveSupport::TestCase
  def setup
    WaiverWire.delete_all
    @valid_params = {
      user: User.find(8),
      player_out: NflPlayer.find(3),
      player_in: NflPlayer.find(4),
      game_week: GameWeek.find(2),
      incoming_priority: 5
    }
    @params = [{
      user: User.find(1),
      player_out: NflPlayer.find(8),
      player_in: NflPlayer.find(44),
      game_week: GameWeek.find(2),
      incoming_priority: 1
    }, {
      user: User.find(1),
      player_out: NflPlayer.find(8),
      player_in: NflPlayer.find(4),
      game_week: GameWeek.find(2),
      incoming_priority: 2
    }, {
      user: User.find(2),
      player_out: NflPlayer.find(24),
      player_in: NflPlayer.find(46),
      game_week: GameWeek.find(2),
      incoming_priority: 1
    }, {
      user: User.find(2),
      player_out: NflPlayer.find(25),
      player_in: NflPlayer.find(45),
      game_week: GameWeek.find(2),
      incoming_priority: 2
    }, {
      user: User.find(2),
      player_out: NflPlayer.find(26),
      player_in: NflPlayer.find(44),
      game_week: GameWeek.find(2),
      incoming_priority: 3
    }, {
      user: User.find(2),
      player_out: NflPlayer.find(27),
      player_in: NflPlayer.find(47),
      game_week: GameWeek.find(2),
      incoming_priority: 4
    }]
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

  test 'correctly resolves only the first of the users waiver wire request as they both have same outgoing player' do
    Timecop.travel(Time.zone.now + 7.days) do
      WaiverWire.create!(@params)
      user_1 = WaiverWire.find_by user: 1, incoming_priority: 1
      user_1_second_round = WaiverWire.find_by user: 1, incoming_priority: 2
      gw = GameWeek.find_by number: WithGameWeek.current_game_week

      WaiverWire.resolve
      assert user_1.user.team_for_current_game_week.match_players
        .include? MatchPlayer.find_by nfl_player_id: user_1['player_in_id'].to_i, game_week_id: gw.id
      assert user_1_second_round.user.team_for_current_game_week.match_players
        .exclude? MatchPlayer.find_by nfl_player_id: user_1_second_round['player_in_id'].to_i, game_week_id: gw.id
    end
  end

  test 'correct user gets incoming player based on the order of last weeks results' do
    Timecop.travel(Time.zone.now + 7.days) do
      WaiverWire.create!(@params)
      u = WaiverWire.find_by user: 2
      assert u.user.team_for_current_game_week.match_players
        .exclude? MatchPlayer.find_by nfl_player_id: u['player_in_id'].to_i
      WaiverWire.resolve
      assert u.user.team_for_current_game_week.match_players
        .exclude? MatchPlayer.find_by nfl_player_id: u['player_in_id'].to_i
    end
  end

  test 'correct user gets incoming player despite someone requesting him in a later round' do
    Timecop.travel(Time.zone.now + 7.days) do
      WaiverWire.create!(@params)
      u1 = WaiverWire.find_by user: 1, incoming_priority: 1
      u2 = WaiverWire.find_by user: 2, incoming_priority: 3
      gw = GameWeek.find_by number: WithGameWeek.current_game_week

      assert_equal u1['player_in_id'].to_i, u2['player_in_id'].to_i
      assert_not_equal u1['incoming_priorirty'].to_i, u2['incoming_priority'].to_i
      WaiverWire.resolve
      assert u1.user.team_for_current_game_week.match_players
        .include? MatchPlayer.find_by nfl_player_id: u1['player_in_id'].to_i, game_week_id: gw.id
      assert u2.user.team_for_current_game_week.match_players
        .exclude? MatchPlayer.find_by nfl_player_id: u2['player_in_id'].to_i, game_week_id: gw.id
    end
  end

  test 'adding two waiver requests, one that does not get executed gets removed afterwards' do
    Timecop.travel(Time.zone.now + 7.days) do
      WaiverWire.create!(@params[0])
      old_length = WaiverWire.count

      params = @params[0]
      params[:player_in] = NflPlayer.find(5)
      params[:incoming_priority] = 2
      WaiverWire.create!(params)
      assert_equal old_length + 1, WaiverWire.count

      WaiverWire.resolve
      refute WaiverWire.exists?(user: params[:user], incoming_priority: params[:incoming_priority],
                                player_in: params[:player_in]), 'Un-executed waiver is still present'
    end
  end
end
