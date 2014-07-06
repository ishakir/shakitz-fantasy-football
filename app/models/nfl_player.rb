# -*- encoding : utf-8 -*-
class NflPlayer < ActiveRecord::Base
  include WithGameWeek

  belongs_to :nfl_team
  belongs_to :nfl_player_type

  has_many :match_players

  validates :name,
            presence: true

  validates :nfl_player_type,
            presence: true

  def player_for_game_week(game_week)
    game_week_as_number = game_week.to_i
    for_game_week(match_players, game_week_as_number)
  end
end
