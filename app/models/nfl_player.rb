# -*- encoding : utf-8 -*-
class NflPlayer < ActiveRecord::Base
  include WithGameWeek

  belongs_to :nfl_team
  belongs_to :nfl_player_type

  has_many :match_players

  validate :name_type_combination_is_valid

  validates :nfl_player_type,
            presence: true

  validates :nfl_id,
            uniqueness: { allow_blank: true, allow_nil: true }

  def name_type_combination_is_valid
    return unless nfl_player_type.present?
    return if nfl_player_type.position_type == "D"
    return if name.present?
    errors.add(:name, "Type is not D and name is not present!")
  end

  def player_for_game_week(game_week)
    game_week_as_number = game_week.to_i
    for_game_week(match_players, game_week_as_number)
  end

  def player_for_current_game_week
    for_current_game_week(match_players)
  end
end
