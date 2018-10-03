class StatsController < ApplicationController
  def show
    current_game_week = WithGameWeek.current_game_week
    current_game_week_with_some_stats = WithGameWeek.current_unlocked_game_week - 1
    game_week_teams = all_game_week_teams(current_game_week)
    without_current_week = all_game_week_teams_without_current(current_game_week)

    @bench_greater_than_team = bench_greater_than_team(without_current_week)
    @bench_greater_than_one_hundred = bench_greater_than_one_hundred(without_current_week)
    @bench_rows = rows_for_bench_table(game_week_teams, current_game_week)
    @perfect_team_rows = rows_for_perfect_team_table(game_week_teams, current_game_week)
    @points = cumulative_points_hash(current_game_week_with_some_stats)
    @last_comment = timestamp_of_last_comment
    @top_stats = MatchPlayer.top_overall_scorers
  end

  private

  def all_game_week_teams_without_current(current_game_week)
    all_game_week_teams(current_game_week).map do |list|
      list[0...-1]
    end
  end

  def all_game_week_teams(current_game_week)
    User.all.map do |user|
      (1..current_game_week).map do |game_week|
        user.team_for_game_week(game_week)
      end
    end
  end

  def cumulative_points_hash(game_week)
    Hash[
      User.all.map do |user|
        [user.name, cumulative_points_for_user(user, game_week)]
      end
    ]
  end

  def cumulative_points_for_user(user, game_week)
    sum = 0
    points_for_each_game_week = (1..game_week).map do |gw|
      user.team_for_game_week(gw).points
    end
    cumulative_sum = points_for_each_game_week.map { |points| sum += points }
    cumulative_sum.each_with_index.map do |cumulative_points, index|
      # index + 1 is the number of gameweeks up till now
      cumulative_points / (index + 1)
    end
  end

  def rows_for_perfect_team_table(all_game_week_teams, game_week)
    rows = {}
    all_game_week_teams.each do |game_week_teams|
      rows[game_week_teams[0].user] = {
        total_perfect_team_points: game_week_teams.map(&:perfect_team_points).sum,
        points_dropped: game_week_teams.map { |gwt| gwt.perfect_team_points - gwt.points }.sum,
        wins: 0
      }
    end

    add_perfect_team_wins(rows, game_week)
  end

  def add_perfect_team_wins(rows, game_week)
    (1...game_week).each do |gw|
      user = User.all.map { |u| u.team_for_game_week(gw) }.max_by(&:perfect_team_points).user
      rows[user][:wins] = rows[user][:wins] + 1
    end

    rows
  end

  def rows_for_bench_table(all_game_week_teams, game_week)
    rows = {}
    all_game_week_teams.each do |game_week_teams|
      rows[game_week_teams[0].user] = {
        total_bench_points: game_week_teams.map(&:bench_points).sum,
        wins: 0
      }
    end

    add_bench_of_the_week_wins(rows, game_week)
  end

  def add_bench_of_the_week_wins(rows, game_week)
    (1...game_week).each do |gw|
      user = User.all.map { |u| u.team_for_game_week(gw) }.max_by(&:bench_points).user
      rows[user][:wins] = rows[user][:wins] + 1
    end

    rows
  end

  def bench_greater_than_one_hundred(without_current_week)
    @bench_greater_than_one_hundred = without_current_week.flatten.select do |game_week_team|
      game_week_team.bench_points > 100
    end
  end

  def bench_greater_than_team(without_current_week)
    without_current_week.flatten.select do |game_week_team|
      game_week_team.bench_points > game_week_team.points
    end
  end
end
