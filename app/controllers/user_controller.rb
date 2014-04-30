# -*- encoding : utf-8 -*-
class UserController < ApplicationController
  USER_ID_KEY = :user_id
  USER_NAME_KEY = :user_name
  TEAM_NAME_KEY = :team_name
  GAME_WEEK_KEY = :game_week

  def create
    validate_all_parameters([USER_NAME_KEY, TEAM_NAME_KEY], params)

    user = User.new
    update_user_entity(user, params)

    redirect_to action: :show_all
  end

  def show_all
    @users = User.all
  end

  def show
    validate_all_parameters([USER_ID_KEY], params)

    user_id = params[USER_ID_KEY]

    @user = User.find(user_id)
  end

  def game_week_team
    validate_all_parameters([USER_ID_KEY, GAME_WEEK_KEY], params)

    user_id = params[USER_ID_KEY]
    game_week = params[GAME_WEEK_KEY]

    @user = User.find(user_id)
    @game_week_team = find_game_week_team(user_id, game_week)
  end

  def update
    validate_all_parameters([USER_ID_KEY], params)
    validate_at_least_number_of_parameters([USER_NAME_KEY, TEAM_NAME_KEY], params, 1)

    user = User.find(params[USER_ID_KEY])
    update_user_entity(user, params)

    redirect_to action: :show_all
  end

  def delete
    validate_all_parameters([USER_ID_KEY], params)

    user = User.find(params[USER_ID_KEY])
    user.destroy!

    redirect_to action: :show_all
  end

  # Subroutines
  def update_user_entity(user, params)
    user.name = params[USER_NAME_KEY] if params.key?(USER_NAME_KEY)
    user.team_name = params[TEAM_NAME_KEY] if params.key?(TEAM_NAME_KEY)

    user.save!
  end

  def find_game_week_team(user_id, game_week)
    gwt_obj_list = GameWeekTeam.where(user_id: user_id).includes(:game_week).where('game_weeks.number' => game_week)

    # There should only we one of these
    no_of_gwt_objs = gwt_obj_list.size
    if no_of_gwt_objs == 0
      fail ActiveRecord::RecordNotFound, "Didn't find a record with user_id '#{user_id}' and game week '#{game_week}'"
    elsif no_of_gwt_objs > 1
      fail ApplicationHelper::IllegalStateError, "Found #{no_of_gwt_objs} game week teams with uid '#{user_id}' and game week '#{game_week}'"
    end

    # Return what must be the only element
    gwt_obj_list.first
  end
end
