class UserSummary
  def initialize(user)
    @id        = user.id
    @name      = user.name
    @team_name = user.team_name

    @game_weeks = game_weeks(user)
  end

  private

  def game_weeks(user)
    Hash[
      (1 .. WithGameWeek.current_game_week).map do |game_week|
        [game_week, {url: "api/users/#{@id}/game_week/#{game_week}" }]
      end
    ]
  end
end