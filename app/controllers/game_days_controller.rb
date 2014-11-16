class GameDaysController < ApplicationController
  NO_QBS_TO_SELECT = 2
  NO_RBS_TO_SELECT = 2
  NO_WRS_TO_SELECT = 3
  NO_TES_TO_SELECT = 2
  NO_DS_TO_SELECT  = 1
  NO_KS_TO_SELECT  = 2

  MIN_NO_WRS = 2

  WR_WILDCARD_INDEX = 2
  TE_WILDCARD_INDEX = 1
  K_WILDCARD_INDEX  = 1

  GAME_WEEK_KEY = :game_week
  PLAYER_ID_KEY = :player_id

  def show_no_game_week
    redirect_to "/game_day/#{WithGameWeek.current_game_week}"
  end

  def show
    validate_all_parameters([GAME_WEEK_KEY], params)
    @page_game_week = params[GAME_WEEK_KEY].to_i
    @current_game_week = WithGameWeek.current_game_week
    @player_data = return_nfl_player_and_team_data.to_json
    @users = User.all.sort_by { |u| -u.team_for_game_week(@page_game_week).points }
    @best_team = find_ten_best_players(@page_game_week)
  end

  def find_ten_best_players(game_week)
    game_week = GameWeek.find_unique_with(game_week)

    top_qbs = find_top_of_type(NflPlayerType::QB, NO_QBS_TO_SELECT, game_week)
    top_rbs = find_top_of_type(NflPlayerType::RB, NO_RBS_TO_SELECT, game_week)
    top_wrs = find_top_of_type(NflPlayerType::WR, NO_WRS_TO_SELECT, game_week)
    top_tes = find_top_of_type(NflPlayerType::TE, NO_TES_TO_SELECT, game_week)
    top_ds  = find_top_of_type(NflPlayerType::D,  NO_DS_TO_SELECT,  game_week)
    top_ks  = find_top_of_type(NflPlayerType::K,  NO_KS_TO_SELECT,  game_week)

    best_team(
      qbs: top_qbs,
      rbs: top_rbs,
      wrs: top_wrs,
      tes: top_tes,
      ds: top_ds,
      ks: top_ks
    )
  end

  def which_team_has_player
    validate_all_parameters([GAME_WEEK_KEY, PLAYER_ID_KEY], params)

    game_week = params[GAME_WEEK_KEY]
    nfl_player = NflPlayer.find(params[PLAYER_ID_KEY])
    match_player = nfl_player.player_for_game_week(game_week)

    game_week_team_players = GameWeekTeamPlayer.where(match_player: match_player)
    found_user = nil if game_week_team_players.empty?
    found_user = game_week_team_players.first.game_week_team.user unless game_week_team_players.empty?

    team_data = nil if found_user.nil?
    team_data = {
      name: found_user.name,
      team_name: found_user.team_name,
      playing: game_week_team_players.first.playing
    } unless found_user.nil?

    return_data = { data: team_data }

    respond_to do |format|
      format.json { render json: return_data }
    end
  end

  private

  def best_team(params)
    best_team = params[:qbs].concat(params[:rbs])
                .concat(params[:ds])
                .concat(params[:wrs].first(MIN_NO_WRS))
                .push(params[:tes].first)
                .push(params[:ks].first)

    other_players = [params[:wrs][WR_WILDCARD_INDEX], params[:tes][TE_WILDCARD_INDEX], params[:ks][K_WILDCARD_INDEX]]
    best_team.push(
      other_players.max_by(&:points)
    )

    best_team
  end

  def find_top_of_type(type, number, game_week)
    MatchPlayer
      .joins(:nfl_player)
      .where(game_week: game_week, nfl_players: { nfl_player_type_id: NflPlayerType.find_unique_with(type) })
      .order(points: :desc)
      .limit(number)
  end

  def find_player(users, _name, game_week)
    users.each do |user|
      user.team_for_game_week(game_week).match_players do |match_player|
        return user if match_player.nfl_player.name
      end
    end
    nil
  end
end
