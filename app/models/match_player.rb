class MatchPlayer < ActiveRecord::Base
  belongs_to :nfl_player
  belongs_to :game_week

  has_many :game_week_team_players
  has_many :game_week_teams, through: :game_week_team_players

  validates_presence_of :nfl_player
  validates_presence_of :game_week

  validates_uniqueness_of :nfl_player, scope: :game_week, if: :player_and_game_week_are_present

  def player_and_game_week_are_present
    nfl_player.present? && game_week.present?
  end

  def points
    total_points = 0

    # Add points generally gained by QBs / WRs
    total_points += passing_yards_points
    total_points += passing_td_points

    total_points += offensive_sack_points
    total_points += offensive_safety_points
    total_points += qb_pick_points

    # Add points generally gained by RBs
    total_points += rushing_yards_points
    total_points += rushing_td_points

    total_points += fumble_points

    # Add points generally gained by Defence
    total_points += defensive_td_points
    total_points += defensive_sack_points
    total_points += turnover_points
    total_points += defensive_safety_points

    # Add points generally gained by Kickers
    total_points += point_conversion_points
    total_points += kicker_points_points

    total_points += blocked_kicks_points

    # Return total points
    total_points
  end

  # Points from QB / Reciever actions
  def passing_yards_points
    points_per_number_of_attribute(passing_yards, 30)
  end

  def passing_td_points
    passing_td * 3
  end

  def offensive_sack_points
    -1 * offensive_sack
  end

  def offensive_safety_points
    -1 * offensive_safety
  end

  def qb_pick_points
    -2 * qb_pick
  end

  # Points from RB actions
  def rushing_yards_points
    points_per_number_of_attribute(rushing_yards, 10)
  end

  def rushing_td_points
    rushing_td * 6
  end

  def fumble_points
    -2 * fumble
  end

  # Points from Defence actions
  def defensive_td_points
    defensive_td * 6
  end

  def defensive_sack_points
    defensive_sack
  end

  def turnover_points
    turnover * 2
  end

  def defensive_safety_points
    defensive_safety * 2
  end

  # Points from Kicker actions
  def point_conversion_points
    point_conversion
  end

  def kicker_points_points
    kicker_points
  end

  def blocked_kicks_points
    -3 * blocked_kicks
  end

  # Utility Methods
  def points_per_number_of_attribute(attribute, how_many_per_point)
    (attribute - (attribute % how_many_per_point)) / how_many_per_point
  end
end
