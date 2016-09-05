require 'best_team'

class GameDaysController < ApplicationController
  GAME_WEEK_KEY = :game_week
  PLAYER_ID_KEY = :player_id

  def show_no_game_week
    redirect_to "/game_day/#{WithGameWeek.current_game_week}"
  end

  def show
    validate_all_parameters([GAME_WEEK_KEY], params)
    @page_game_week = params[GAME_WEEK_KEY].to_i
    @current_game_week = WithGameWeek.current_game_week
    @player_data = return_nfl_player_and_team_data
    @users = User.all.sort_by { |u| -u.team_for_game_week(@page_game_week).points }
    @best_team = best_players
    @last_comment = timestamp_of_last_comment
  end

  def which_team_has_player
    validate_all_parameters([GAME_WEEK_KEY, PLAYER_ID_KEY], params)
    nfl_player = NflPlayer.find(params[PLAYER_ID_KEY])
    game_week = params[GAME_WEEK_KEY]

    respond_to do |format|
      format.json do
        render json: {
          data: form_team_data(nfl_player, game_week)
        }
      end
    end
  end

  private

  def best_players
    # Prevents exception on opening gameweek, only return best players if match players exist
    if MatchPlayer.exists?
      BestTeam.find_ten_best_players(
        MatchPlayer.where(game_week: GameWeek.find_by(number: @page_game_week)).map { |mp| [mp.nfl_player, mp.points] }
      )
    else
      []
    end
  end

  def form_team_data(nfl_player, game_week)
    game_week_team_players = GameWeekTeamPlayer.where(
      match_player: nfl_player.player_for_game_week(game_week)
    )
    return nil if game_week_team_players.empty?

    found_user = game_week_team_players.first.game_week_team.user
    {
      name: found_user.name,
      team_name: found_user.team_name,
      playing: game_week_team_players.first.playing
    }
  end
end
