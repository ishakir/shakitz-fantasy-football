class GameDaysController < ApplicationController
  BEST_TEAM_SIZE = 10

  BEST_TEAM_DEFINITION = {
    NflPlayerType::QB => {
      min: 2,
      max: 2
    },
    NflPlayerType::RB => {
      min: 2,
      max: 2
    },
    NflPlayerType::WR => {
      min: 2,
      max: 3
    },
    NflPlayerType::TE => {
      min: 1,
      max: 2
    },
    NflPlayerType::K => {
      min: 1,
      max: 2
    },
    NflPlayerType::D => {
      min: 1,
      max: 1
    }
  }

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
    @best_team = find_ten_best_players(@page_game_week)
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

  def find_ten_best_players(game_week)
    game_week = GameWeek.find_unique_with(game_week)

    player_arrays = BEST_TEAM_DEFINITION.keys.reduce(best: [], remaining: []) do |player_arrays_acc, player_type|
      add_players_of_type(player_type, player_arrays_acc, game_week)
    end

    best_players = player_arrays[:best]
    remaining_players = player_arrays[:remaining]

    best_players.concat(remaining_players.sort_by(&:points).last(BEST_TEAM_SIZE - best_players.size))
  end

  def add_players_of_type(player_type, player_arrays, game_week)
    best_players = player_arrays[:best]
    remaining_players = player_arrays[:remaining]

    max = BEST_TEAM_DEFINITION[player_type][:max]
    min = BEST_TEAM_DEFINITION[player_type][:min]

    best_of_type = find_top_of_type(player_type, max, game_week)
    best_players.concat(best_of_type.first(min))
    remaining_players.concat(best_of_type.last(max - min))

    { best: best_players, remaining: remaining_players }
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
