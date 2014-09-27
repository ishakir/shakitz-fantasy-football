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
end
