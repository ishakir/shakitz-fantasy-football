# -*- encoding : utf-8 -*-
class MatchPlayer < ActiveRecord::Base
  belongs_to :nfl_player
  belongs_to :game_week

  has_many :game_week_team_players
  has_many :game_week_teams, through: :game_week_team_players

  validates :nfl_player,
            presence: true,
            uniqueness: { scope: :game_week, if: :both_are_present }

  validates :game_week,
            presence: true

  def both_are_present
    nfl_player.present? && game_week.present?
  end

  def points
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
    points_per_number_of_attribute(passing_yards, 30)
  end

  def passing_td_points
    passing_tds * 4
  end

  def passing_twoptm_points
    passing_twoptm * 2
  end

  def sacks_made_points
    -1 * sacks_made
  end

  def offensive_safety_points
    -1 * offensive_safety
  end

  def interceptions_thrown_points
    -2 * interceptions_thrown
  end

  # Points from WR actions
  def receiving_yards_points
    points_per_number_of_attribute(receiving_yards, 10)
  end

  def receiving_td_points
    receiving_tds * 6
  end

  def receiving_twoptm_points
    receiving_twoptm * 2
  end

  # Points from RB actions
  def rushing_yards_points
    points_per_number_of_attribute(rushing_yards, 10)
  end

  def rushing_td_points
    rushing_tds * 6
  end

  def rushing_twoptm_points
    rushing_twoptm * 2
  end

  def fumbles_lost_points
    -2 * fumbles_lost
  end

  def fumbles_won_points
    2 * fumbles_won
  end

  # Points from Defence actions
  def defense_touchdowns_points
    defense_touchdowns * 6
  end

  def times_sacked_points
    times_sacked
  end

  def interceptions_caught_points
    interceptions_caught * 2
  end

  def defensive_safety_points
    defensive_safety * 2
  end

  def points_conceded_points
    if(nfl_player.nfl_player_type.position_type == 'D')
      case points_conceded
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
    field_goals_kicked * 3
  end

  def extra_points_kicked_points
    extra_points_kicked
  end

  # Utility Methods
  def points_per_number_of_attribute(attribute, how_many_per_point)
    (attribute - (attribute % how_many_per_point)) / how_many_per_point
  end
end
