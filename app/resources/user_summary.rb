class UserSummary
  def initialize(user)
    @id        = user.id
    @name      = user.name
    @team_name = user.team_name

    @points     = points(user)
    @game_weeks = game_weeks(user)
  end

  private

  def game_weeks(_user)
    Hash[
      (1..WithGameWeek.current_game_week).map do |game_week|
        [game_week, { url: "api/users/#{@id}/game_week/#{game_week}" }]
      end
    ]
  end

  def points(user)
    {
      total: user.points,
      url: "api/users/#{@id}/points"
    }
  end
end
