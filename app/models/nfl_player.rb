# -*- encoding : utf-8 -*-
class NflPlayer < ActiveRecord::Base
  include WithGameWeek

  belongs_to :nfl_team
  belongs_to :nfl_player_type

  has_many :match_players
  has_many :inward_waiver_players, class_name: 'WaiverWire', foreign_key: 'player_in_id'
  has_many :outward_waiver_players, class_name: 'WaiverWire', foreign_key: 'player_out_id'
  validates :name,
            presence: true

  validates :nfl_player_type,
            presence: true

  validates :nfl_id,
            uniqueness: { allow_blank: true, allow_nil: true }

  def player_for_game_week(game_week)
    game_week_as_number = game_week.to_i
    for_game_week(match_players, game_week_as_number)
  end

  def player_for_current_game_week
    for_current_game_week(match_players)
  end
end
