# -*- encoding : utf-8 -*-
class Fixture < ActiveRecord::Base
  belongs_to :home_team,
             foreign_key: :home_team_id,
             class_name: 'GameWeekTeam'

  belongs_to :away_team,
             foreign_key: :away_team_id,
             class_name: 'GameWeekTeam'

  validates :home_team,
            presence: true

  validates :away_team,
            presence: true

  validate :both_have_same_gameweek
  validate :both_have_different_users

  def both_have_same_gameweek
    return unless home_team.present? && away_team.present?
    home_team_gw = home_team.game_week.number
    away_team_gw = away_team.game_week.number
    return unless home_team_gw != away_team_gw
    errors.add(:teams, "Home Team game_week: #{home_team_gw} does not equal Away Team game_week: #{away_team_gw}")
  end

  def both_have_different_users
    return unless home_team.present? && away_team.present?
    home_team_user_id = home_team.user.id
    away_team_user_id = away_team.user.id
    return unless home_team_user_id == away_team_user_id
    errors.add(:teams, "Home Team user id: #{home_team_user_id} is equal to Away Team user id: #{away_team_user_id}")
  end

  def opponent_of(team)
    assert_team_is_playing(team)
    return home_team if team.id == away_team.id
    return away_team if team.id == home_team.id
  end

  def assert_team_is_playing(team)
    return if team.id == home_team.id || team.id == away_team.id
    raise ArgumentError, "Team provided with id #{team.id} is not playing in this fixture!"
  end

  def winner
    home_won = (home_team.points > away_team.points)
    return home_team if home_won
    return away_team unless drawn?
    nil
  end

  def won_by?(team)
    assert_team_is_playing(team)
    return false if drawn?
    winner.id == team.id
  end

  def drawn?
    home_points = home_team.points
    away_points = away_team.points
    home_points == away_points
  end

  def lost_by?(team)
    assert_team_is_playing(team)
    return false if drawn?
    loser.id == team.id
  end

  def loser
    home_lost = (away_team.points > home_team.points)
    return home_team if home_lost
    return away_team unless drawn?
  end
end
