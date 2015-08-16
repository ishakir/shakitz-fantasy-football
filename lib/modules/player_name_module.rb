module PlayerNameModule
  def return_player_name_for_active_game_week_team(user_id)
    user_id = session[:user_id] if user_id <= 0
    team = User.find(user_id).team_for_current_game_week.match_players
    team.map do |player|
      [player.nfl_player_id, player.nfl_player.name, player.nfl_player.nfl_team.name]
    end
  end
end
