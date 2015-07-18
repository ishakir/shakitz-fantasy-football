# -*- encoding : utf-8 -*-
class UserController < ApplicationController
  USER_ID_KEY = :user_id
  USER_NAME_KEY = :name
  TEAM_NAME_KEY = :team_name
  PASSWORD_KEY = :password
  PASSWORD_CONFIRMATION_KEY = :password_confirmation
  GAME_WEEK_KEY = :game_week

  PLAYING_PLAYER_ID_KEY = :playing_player_id
  BENCHED_PLAYER_ID_KEY = :benched_player_id

  def create
    validate_password(params[:user])
    validate_all_parameters([USER_NAME_KEY, TEAM_NAME_KEY, PASSWORD_KEY, PASSWORD_CONFIRMATION_KEY], params[:user])
    user = User.new
    if update_user_entity(user, params[:user]) && create_all_game_week_teams(user)
      redirect_to action: :home, notice: 'Signed up!'
    else
      render 'create'
    end
  end

  def home
    @t1 = Time.now
    @users = User.all
    @fixtures = Fixture.all
    @game_week = WithGameWeek.current_game_week
    @max_number_game_weeks = Settings.number_of_gameweeks
    @users = @users.sort_by { |u| -u.points }
  end

  def show
    validate_all_parameters([USER_ID_KEY], params)

    put_game_week_data_in_assigns(params)

    @nfl_players = return_nfl_player_and_team_data
    @stats = return_my_player_point_info
    @user = User.find(params[USER_ID_KEY])
  end

  def declare_roster
    validate_everything_for_declare_roster(params)

    # First find the game_week_team
    update_game_week_team_roster(params)

    render json: ok_response
  rescue ArgumentError => e
    render status: :unprocessable_entity, json: { response: e.message }
  end

  def update
    validate_all_parameters([USER_ID_KEY], params)
    validate_at_least_number_of_parameters([USER_NAME_KEY, TEAM_NAME_KEY], params, 1)

    user = User.find(params[USER_ID_KEY])
    update_user_entity(user, params)

    redirect_to action: :home
  end

  def delete
    validate_all_parameters([USER_ID_KEY], params)

    user = User.find(params[USER_ID_KEY])
    user.destroy!

    redirect_to action: :home
  end

  def api_all
    user_summaries = User.all.map do |user|
      UserSummary.new(user)
    end

    render json: user_summaries
  end

  def api_game_week
    validate_all_parameters([USER_ID_KEY, GAME_WEEK_KEY], params)

    user_id = params[USER_ID_KEY].to_i
    game_week = params[GAME_WEEK_KEY].to_i

    validate_user_id_and_game_week(user_id, game_week)

    render json: UserGameWeek.new(User.find(user_id).team_for_game_week(game_week))
  end

  def api_points
    validate_all_parameters([USER_ID_KEY], params)
    user_id = params[USER_ID_KEY].to_i
    fail ArgumentError, "#{params[USER_ID_KEY]} is not a valid user id!" if user_id <= 0

    render json: UserPoints.new(User.find(user_id))
  end

  private

  def validate_user_id_and_game_week(user_id, game_week)
    fail ArgumentError, "#{params[USER_ID_KEY]} is not a valid user id!" if user_id <= 0
    fail ArgumentError, "Game Week #{game_week} hasn't happened yet!" if game_week > WithGameWeek.current_game_week
  end

  def validate_everything_for_declare_roster(params)
    validate_all_parameters([USER_ID_KEY, GAME_WEEK_KEY, PLAYING_PLAYER_ID_KEY, BENCHED_PLAYER_ID_KEY], params)
    validate_id_length(params[PLAYING_PLAYER_ID_KEY], params[BENCHED_PLAYER_ID_KEY])
    validate_game_week_active(params[GAME_WEEK_KEY].to_i)
  end

  def put_game_week_data_in_assigns(params)
    @active_gameweek = WithGameWeek.current_game_week
    @game_week = params.key?(GAME_WEEK_KEY) ? @game_week = params[GAME_WEEK_KEY].to_i : @active_gameweek
    @game_week_time_obj = { locked: GameWeek.find_unique_with(@game_week).locked? }
  end

  def update_game_week_team_roster(params)
    game_week_team = User.find(params[USER_ID_KEY]).team_for_game_week(params[GAME_WEEK_KEY])
    update_players_status(params[PLAYING_PLAYER_ID_KEY], game_week_team, true)
    update_players_status(params[BENCHED_PLAYER_ID_KEY], game_week_team, false)
  end

  def update_players_status(match_player_ids, game_week_team, status)
    match_player_ids.each do |player|
      game_week_team_player = GameWeekTeamPlayer.find_unique_with(game_week_team, MatchPlayer.find(player))
      game_week_team_player.playing = status
      game_week_team_player.save!
    end
  end

  def validate_password(params)
    return if params[PASSWORD_KEY] == params[PASSWORD_CONFIRMATION_KEY]
    fail ArgumentError, 'Password and password confirmation do not match'
  end

  def validate_game_week_active(game_week_number)
    game_week = GameWeek.find_unique_with(game_week_number)
    fail ArgumentError, 'Gameweek is currently locked, unable to make changes' if game_week.locked?
  end

  def update_user_entity(user, params)
    user.name = params[USER_NAME_KEY] if params.key?(USER_NAME_KEY)
    user.team_name = params[TEAM_NAME_KEY] if params.key?(TEAM_NAME_KEY)
    user.password = params[PASSWORD_KEY] if params.key?(PASSWORD_KEY)

    user.save!
  end

  def create_all_game_week_teams(user)
    all_game_weeks = GameWeek.all
    all_game_weeks.each do |game_week|
      GameWeekTeam.create!(game_week: game_week, user: user)
    end
  end

  def validate_id_length(playing, benched)
    fail ArgumentError, 'Invalid number of active players' if playing.length != 10
    fail ArgumentError, 'Invalid number of benched players' if benched.length != 8
  end

  def show_my_team_info
    payload = return_player_name_for_active_game_week_team
    render json: payload
  end

  def return_my_player_point_info
    user = User.find(params[USER_ID_KEY])
    user.team_for_game_week(@game_week).match_players.to_json
  end

  def return_player_name_for_active_game_week_team(user_id)
    user_id = session[:user_id] if user_id <= 0
    team = User.find(user_id).team_for_current_game_week.match_players
    team.map do |player|
      [player.nfl_player_id, player.nfl_player.name, player.nfl_player.nfl_team.name]
    end
  end

  helper_method :return_player_name_for_active_game_week_team
end
