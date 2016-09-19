# -*- encoding : utf-8 -*-
class GameWeekTeamPlayer < ActiveRecord::Base
  def self.find_unique_with(game_week_team, match_player)
    gwtps = GameWeekTeamPlayer.where(game_week_team: game_week_team, match_player: match_player)

    no_of_gwtps = gwtps.size
    raise ActiveRecord::RecordNotFound, no_record_found_message(game_week_team, match_player) if no_of_gwtps.zero?
    raise IllegalStateError,
          multiple_records_found_message(no_of_gwtps, game_week_team, match_player) if no_of_gwtps > 1

    gwtps.first
  end

  def self.no_record_found_message(game_week_team, match_player)
    "Didn't find a record with game_week_team_id '#{game_week_team.id}' and match_player_id '#{match_player.id}'"
  end

  def self.multiple_records_found_message(no_found, game_week_team, match_player)
    "Found #{no_found} game week team players with game_week_team_id '#{game_week_team.id}'" \
    " and match_player_id '#{match_player.id}'"
  end

  belongs_to :game_week_team
  belongs_to :match_player

  validates :game_week_team,
            presence: true

  validates :match_player,
            presence: true,
            uniqueness: { scope: :game_week_team, if: :both_are_present }

  validate :both_have_same_gameweek

  def both_are_present
    game_week_team.present? && match_player.present?
  end

  def both_have_same_gameweek
    return unless game_week_team.present?
    return unless match_player.present?

    mp_gw = match_player.game_week
    gwt_gw = game_week_team.game_week

    return if gwt_gw.number == mp_gw.number
    errors.add(:base, 'Game Weeks do not match!')
  end
end
