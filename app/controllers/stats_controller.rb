class StatsController < ApplicationController
  def show
    @last_comment = get_timestamp_of_last_comment
    current_game_week = WithGameWeek.current_game_week
    current_game_week_with_some_stats = WithGameWeek.current_unlocked_game_week - 1

    all_game_week_teams = User.all.map do |user|
      (1..current_game_week).map do |game_week|
        user.team_for_game_week(game_week)
      end
    end

    without_current_week = all_game_week_teams.map do |list|
      list[0...-1]
    end

    @bench_greater_than_team = without_current_week.flatten.select do |game_week_team|
      game_week_team.bench_points > game_week_team.points
    end

    @bench_greater_than_one_hundred = without_current_week.flatten.select do |game_week_team|
      game_week_team.bench_points > 100
    end

    rows_hash = {}
    all_game_week_teams.each do |game_week_teams|
      rows_hash[game_week_teams[0].user] = {
        total_bench_points: game_week_teams.map(&:bench_points).sum,
        wins: 0
      }
    end

    (1...current_game_week).each do |game_week|
      user = User.all.map { |u| u.team_for_game_week(game_week) }.max_by(&:bench_points).user
      rows_hash[user][:wins] = rows_hash[user][:wins] + 1
    end

    @rows = rows_hash.map do |user, hash|
      hash['user'] = user
      hash
    end.sort_by do |hash|
      hash['total_bench_points']
    end

    @points = Hash[
      User.all.map do |user|
        sum = 0
        [
          user.name,
          (1..current_game_week_with_some_stats).map do |game_week|
            user.team_for_game_week(game_week).points
          end.map do |points|
            sum += points
          end.each_with_index.map do |cumulative_points, index|
            # index + 1 is the number of gameweeks up till now
            cumulative_points / (index + 1)
          end
        ]
      end
    ]
  end
end
