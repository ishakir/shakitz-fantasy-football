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
    if update_user_entity(user, params[:user]) && create_first_game_week(user)
      redirect_to action: :home, notice: "Signed up!"
    else
      render "create"
    end
  end

  def home
    @users = User.all
  end

  def show
    validate_all_parameters([USER_ID_KEY], params)
    user_id = params[USER_ID_KEY]

    if params.key?(GAME_WEEK_KEY)
      @game_week = params[GAME_WEEK_KEY]
    else
      @game_week = WithGameWeek.current_game_week
    end
    @active_gameweek = WithGameWeek.current_game_week
    @user = User.find(user_id)
  end

  def game_week_team
    validate_all_parameters([USER_ID_KEY, GAME_WEEK_KEY], params)

    user_id = params[USER_ID_KEY]
    game_week = params[GAME_WEEK_KEY]

    @user = User.find(user_id)
    @game_week = game_week
    @game_week_team = GameWeekTeam.find_unique_with(user_id, game_week)
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

  # Subroutines
  def validate_password(params)
    return if params[PASSWORD_KEY] == params[PASSWORD_CONFIRMATION_KEY]
    fail ArgumentError, "Password and password confirmation do not match"
  end

  def update_user_entity(user, params)
    user.name = params[USER_NAME_KEY] if params.key?(USER_NAME_KEY)
    user.team_name = params[TEAM_NAME_KEY] if params.key?(TEAM_NAME_KEY)
    user.password = params[PASSWORD_KEY] if params.key?(PASSWORD_KEY)

    user.save!
  end

  def create_first_game_week(user)
    game_week_team = GameWeekTeam.new
    game_week_team.user = user
    game_week_team.game_week = GameWeek.find_unique_with(1)

    game_week_team.save!
  end

  def declare_roster
    validate_all_parameters([USER_ID_KEY, GAME_WEEK_KEY, PLAYING_PLAYER_ID_KEY, BENCHED_PLAYER_ID_KEY], params)
    payload = validate_id_length(params[PLAYING_PLAYER_ID_KEY], params[BENCHED_PLAYER_ID_KEY])
    if payload[:status] == 400
      render json: payload
    else
      # First find the game_week_team
      user = User.find(params[USER_ID_KEY])
      game_week_team = user.team_for_game_week(params[GAME_WEEK_KEY])
      params[PLAYING_PLAYER_ID_KEY].each do |p|
        # Find the match_player
        player_gwt = GameWeekTeamPlayer.find_unique_with(game_week_team, MatchPlayer.find(p))
        player_gwt.playing = true
        player_gwt.save!
      end

      params[BENCHED_PLAYER_ID_KEY].each do |p|
        # Find the match_player
        player_gwt = GameWeekTeamPlayer.find_unique_with(game_week_team, MatchPlayer.find(p))
        player_gwt.playing = false
        player_gwt.save!
      end
      render json: payload
    end
  end

  def swap_players
    validate_all_parameters([USER_ID_KEY, GAME_WEEK_KEY, PLAYING_PLAYER_ID_KEY, BENCHED_PLAYER_ID_KEY], params)

    # First find the game_week_team
    user = User.find(params[USER_ID_KEY])
    game_week_team = user.team_for_game_week(params[GAME_WEEK_KEY])

    # Find the match_player
    playing_player = MatchPlayer.find(params[PLAYING_PLAYER_ID_KEY])
    benched_player = MatchPlayer.find(params[BENCHED_PLAYER_ID_KEY])

    playing_gwtp = GameWeekTeamPlayer.find_unique_with(game_week_team, playing_player)
    benched_gwtp = GameWeekTeamPlayer.find_unique_with(game_week_team, benched_player)

    # Check that both are playing / not playing as expected
    fail ArgumentError, "Playing player was not found to be playing" unless playing_gwtp.playing
    fail ArgumentError, "Benched player was not found to be benched" if benched_gwtp.playing

    # Swap them
    playing_gwtp.playing = false
    playing_gwtp.save!

    benched_gwtp.playing = true
    benched_gwtp.save!
  end

  def validate_id_length(playing, benched)
    if playing.length != 10
      return { response: "Invalid number of active players", status: 400 }
    end
    if benched.length != 8
      return { response: "Invalid number of benched players", status: 400 }
    end
    { response: "OK", status: 200 }
  end
end
