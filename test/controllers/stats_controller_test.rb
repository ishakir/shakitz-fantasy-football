require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  test 'bench greater than team not reported during current week' do
    bench_greater = get_assigns(:show, :bench_greater_than_team)
    assert_empty bench_greater
  end

  test 'bench greater than team' do
    Timecop.travel(Time.zone.now + 7.days) do
      bench_greater = get_assigns(:show, :bench_greater_than_team)
      assert_equal 1, bench_greater.size

      assert_equal User.find(2).team_for_game_week(1), bench_greater[0]
    end
  end

  test 'bench greater than 100 not reported during current week' do
    bench_greater = get_assigns(:show, :bench_greater_than_one_hundred)
    assert_empty bench_greater
  end

  test 'bench greater than 100' do
    Timecop.travel(Time.zone.now + 7.days) do
      bench_greater = get_assigns(:show, :bench_greater_than_one_hundred)
      assert_equal 1, bench_greater.size

      assert_equal User.find(2).team_for_game_week(1), bench_greater[0]
    end
  end

  test 'rows contains all users' do
    rows = get_assigns(:show, :rows)
    assert_equal 8, rows.length
  end

  test 'rows has the correctly computed number of wins during game week' do
    rows = get_assigns(:show, :rows)
    assert_equal 0, rows[User.find(2)][:wins]
  end

  test 'rows has the correctly computed number of wins after game week' do
    Timecop.travel(Time.zone.now + 7.days) do
      rows = get_assigns(:show, :rows)
      assert_equal 1, rows[User.find(2)][:wins]
    end
  end

  test 'rows has the correctly computed sum' do
    Timecop.travel(Time.zone.now + 14.days) do
      rows = get_assigns(:show, :rows)
      assert_equal 56, rows[User.find(1)][:total_bench_points]
    end
  end

  test 'cumulative points per week is calculated correctly' do
    Timecop.travel(Time.zone.now + 14.days) do
      points = get_assigns(:show, :points)
      assert_equal [40, 20], points['Mike Sharwood']
    end
  end
end
