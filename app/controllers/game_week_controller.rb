class GameWeekController < ApplicationController
  def get_gw_team_points
    uid = params[:uid]
    gw = params[:gw]
    gw_obj = GameWeekTeam.find_by user_id: uid, gameweek: gw
    @tally = 0
    gw_obj.match_players.each do |player|
      @tally += calculate_player_points_tally(player)
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
    return tally
  end

  def get_gw_roster
  end

  def get_gw_player_points
  
  end
end
