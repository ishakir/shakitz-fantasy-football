class UserPoints
  def initialize(user)
    @user = UserReference.new(user)
    @points = points(user)
  end

  private

  def points(user)
    game_weeks_obj = Hash[
                     (1..WithGameWeek.current_game_week).map do |game_week|
                       game_week(user, game_week)
                     end
                     ]
    {
      total: user.points,
      total_bench: user.bench_points,
      game_weeks: game_weeks_obj
    }
  end

  def game_week(user, game_week)
    game_week_team = user.team_for_game_week(game_week)
    [
      game_week,
      {
        points: game_week_team.points,
        bench_points: game_week_team.bench_points,
        url: "api/users/#{user.id}/game_week/#{game_week}"
      }
    ]
  end
end
