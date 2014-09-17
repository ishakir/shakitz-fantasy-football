require 'points_strategy/base'

module PointsStrategy
  class Nfl < PointsStrategy::Base
    def calculate_points
      total_points = 0

      # Add points generally gained by QBs / WRs
      total_points += passing_yards_points
      total_points += passing_td_points
      total_points += passing_twoptm_points

      total_points += receiving_yards_points
      total_points += receiving_td_points
      total_points += receiving_twoptm_points

      total_points += times_sacked_points

      # total_points += offensive_safety_points
      total_points += interceptions_thrown_points

      # Add points generally gained by RBs
      total_points += rushing_yards_points
      total_points += rushing_td_points
      total_points += rushing_twoptm_points
      total_points += fumbles_lost_points

      # Add points generally gained by Defence
      total_points += defense_touchdowns_points
      total_points += sacks_made_points
      total_points += interceptions_caught_points
      total_points += points_conceded_points
      total_points += fumbles_won_points
      # total_points += defensive_safety_points

      # Add points generally gained by Kickers
      total_points += field_goals_kicked_points
      total_points += extra_points_kicked_points

      # Return total points
      total_points
    end

    # Points from QB / Reciever actions
    def passing_yards_points
      points_per_number_of_attribute(@match_player.passing_yards, 30)
    end

    def passing_td_points
      @match_player.passing_tds * 4
    end

    def passing_twoptm_points
      @match_player.passing_twoptm * 2
    end

    def sacks_made_points
      @match_player.sacks_made
    end

    def offensive_safety_points
      @match_player.offensive_safety * -1
    end

    def interceptions_thrown_points
      @match_player.interceptions_thrown * -2
    end

    # Points from WR actions
    def receiving_yards_points
      points_per_number_of_attribute(@match_player.receiving_yards, 10)
    end

    def receiving_td_points
      @match_player.receiving_tds * 6
    end

    def receiving_twoptm_points
      @match_player.receiving_twoptm * 2
    end

    # Points from RB actions
    def rushing_yards_points
      points_per_number_of_attribute(@match_player.rushing_yards, 10)
    end

    def rushing_td_points
      @match_player.rushing_tds * 6
    end

    def rushing_twoptm_points
      @match_player.rushing_twoptm * 2
    end

    def fumbles_lost_points
      @match_player.fumbles_lost * -2
    end

    def fumbles_won_points
      @match_player.fumbles_won * 2
    end

    # Points from Defence actions
    def defense_touchdowns_points
      @match_player.defense_touchdowns * 6
    end

    def times_sacked_points
      @match_player.times_sacked * -1
    end

    def interceptions_caught_points
      @match_player.interceptions_caught * 2
    end

    def defensive_safety_points
      @match_player.defensive_safety * 2
    end

    def points_conceded_points
      if @match_player.nfl_player.nfl_player_type.position_type == 'D'
        case @match_player.points_conceded
        when 0
          10
        when 1..6
          7
        when 7..13
          4
        when 14..20
          1
        when 21..27
          0
        when 28..34
          -1
        else
          -4
        end
      else
        0
      end
    end

    # Points from Kicker actions
    def field_goals_kicked_points
      @match_player.field_goals_kicked * 3
    end

    def extra_points_kicked_points
      @match_player.extra_points_kicked
    end
  end
end
