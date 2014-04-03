class GameWeekController < ApplicationController
  
  include ApplicationHelper
  
  def get_gw_team_points
    gw_obj = get_game_week_team_from(params)
    
    @tally = 0
    gw_obj.match_players.each do |player|
      @tally += calculate_player_points_tally(player)
    end
  end
  
  def get_total_team_points
    teams = get_user_team(params[:uid])
    @points = 0
    teams.each do |team|
      team.match_players.each do |player|
        @points += calculate_player_points_tally(player)
      end
    end
  end
  
  def calculate_player_points_tally(player)
    tally = 0
    player.attributes.each do |key, value|
        if(key == "passing_yards")
          tally = (value-(value%30))/30
        elsif key == "passing_td"
          tally += (value*3)
        elsif key == "rushing_yards"
          tally += (value-(value%10))/10
        elsif key == "rushing_td"
          tally += (value*6)
        elsif key == "defensive_td"
          tally += (value*6)
        elsif key == "point_conversion" || key == "defensive_sack" || key == "kicker_points"
          tally += value
        elsif key == "turnover" || key == "defensive_safety"
          tally += (value*2)
        elsif key == "offensive_sack" || key == "offensive_safety"
          tally -= value
        elsif key == "fumble" || key == "qb_pick"
          tally -= (value*2)
        elsif key == "blocked_kicks"
          tally -= (value*3)
        else
          #do nothing
        end
    end  
    tally
  end

  def get_gw_roster
    game_week_team = get_game_week_team_from(params)
    @roster = game_week_team.match_players   
  end

  def get_gw_player_points
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
