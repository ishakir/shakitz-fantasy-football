class GameWeekProgresser
  def progress_game_week(previous_game_week_number)
    User.all.each do |user|
      progress_game_week_team(user, previous_game_week_number)
    end
  end

  private

  def progress_game_week_team(user, previous_game_week_number)
    # Get the last and next game week teams
    previous_game_week_team = user.team_for_game_week(previous_game_week_number)
    next_game_week_team = user.team_for_game_week(previous_game_week_number.to_i + 1)

    # For each match player put the player for next week into next weeks team
    previous_game_week_team.match_players.each do |previous_match_player|
      copy_player(previous_match_player, previous_game_week_team, next_game_week_team)
    end
  end

  def copy_player(previous_match_player, previous_game_week_team, next_game_week_team)
    # Get the match player for the next week
    next_match_player = previous_match_player.nfl_player.player_for_game_week(next_game_week_team.game_week.number)

    # Get the previous game week team player
    game_week_team_player = GameWeekTeamPlayer.where(
      match_player: previous_match_player,
      game_week_team: previous_game_week_team
    ).first

    # Create a game week team player for the next week
    GameWeekTeamPlayer.create!(
      match_player: next_match_player,
      game_week_team: next_game_week_team,
      playing: game_week_team_player.playing
    )
  end
end
