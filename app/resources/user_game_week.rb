class UserGameWeek
  def initialize(game_week_team)
    @user = UserReference.new(game_week_team.user)
    @bench = { points: game_week_team.bench_points }
  end
end
