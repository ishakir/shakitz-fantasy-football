class GameWeekController < ApplicationController
  
  include ApplicationHelper
  
  def get_gw_team_points
    gw_obj = get_game_week_team_from(params)
    @tally = gw_obj.points
  end
  
  def get_total_team_points
    teams = get_user_team(params[:uid])
    @points = 0
    teams.each do |team|
      @points += team.points
    end
  end

  def get_gw_roster
    game_week_team = get_game_week_team_from(params)
    @roster = game_week_team.match_players   
  end

  def get_gw_player_points
    pid = params[:pid]
    gw = params[:gw]
    p_list = MatchPlayer.where(:nfl_player_id => pid).includes(:game_week).where("game_weeks.number" => gw)
    if(p_list[0] == nil )
      return;
    end
    @points = p_list[0].points
  end
  
  def get_user_team(uid)
    GameWeekTeam.where("user_id = ?", uid)
  end
  
  def get_game_week_team_from(params)
    
    validate_all_parameters(["uid", "gw"], params)
    
    user_id = params["uid"]
    game_week = params["gw"]
    
    get_game_week_team(user_id, game_week)
  end
  
  def get_game_week_team(user_id, game_week)
    gwt_obj_list = GameWeekTeam.where(:user_id => user_id).includes(:game_week).where("game_weeks.number" => game_week)
    
    # There should only we one of these
    no_of_gwt_objs = gwt_obj_list.size
    if(no_of_gwt_objs == 0)
      raise ActiveRecord::RecordNotFound, "Didn't find a record with user_id '#{user_id}' and game week '#{game_week}'"
    elsif(no_of_gwt_objs > 1)
      raise ApplicationHelper::IllegalStateError, "Found #{no_of_gwt_objs} game week teams with uid '#{user_id}' and game week '#{game_week}'"
    end
    
    # Return what must be the only element
    gwt_obj_list.first
  end

end
