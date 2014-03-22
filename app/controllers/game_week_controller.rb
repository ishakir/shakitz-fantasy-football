class GameWeekController < ApplicationController
  
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
  
  #REFACTOR TO MAKE MORE GENERIC
  def validate_arguments(params)
    if(!params.has_key?("uid"))
      raise ArgumentError, "Expecting 'uid' in params, but could not find it"
    end
    if(!params.has_key?("gw"))
      raise ArgumentError, "Expecting 'gw' in params, but could not find it"
    end
  end
  
  def get_user_team(uid)
      t_obj = GameWeekTeam.where("user_id = ?", uid)
      t_obj
  end
  
  def get_game_week_team_from(params)
    validate_arguments(params)
    
    user_id = params["uid"]
    game_week = params["gw"]
    
    gw_obj = GameWeekTeam.find_by user_id: user_id, gameweek: game_week
    
    if(gw_obj == nil)
      raise ActiveRecord::RecordNotFound, "Query with uid '#{user_id}' and game week '#{game_week}' returned nothing"
    end
    
    # Return gw_obj
    gw_obj  
  end

end
