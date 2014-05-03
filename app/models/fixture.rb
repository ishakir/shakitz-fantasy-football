# -*- encoding : utf-8 -*-
class Fixture < ActiveRecord::Base
  belongs_to :home_team,
             foreign_key: :home_team_id,
             class_name: "GameWeekTeam"

  belongs_to :away_team,
             foreign_key: :away_team_id,
             class_name: "GameWeekTeam"

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
    if home_team_gw != away_team_gw
      errors.add(:teams, "Home Team game_week: #{home_team_gw} does not equal Away Team game_week: #{away_team_gw}")
    end
  end

  def both_have_different_users
    return unless home_team.present? && away_team.present?
    home_team_user_id = home_team.user.id
    away_team_user_id = away_team.user.id
    if home_team_user_id == away_team_user_id
      errors.add(:teams, "Home Team user id: #{home_team_user_id} is equal to Away Team user id: #{away_team_user_id}")
    end
  end
end
