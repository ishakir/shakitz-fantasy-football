class GameWeekTeamPlayer < ActiveRecord::Base
  belongs_to :game_week_team
  belongs_to :match_player

  validates_presence_of :game_week_team
  validates_presence_of :match_player
  validates_uniqueness_of :match_player, scope: :game_week_team, if: :both_are_present
  validate :both_have_same_gameweek

  def both_are_present
    game_week_team.present? && match_player.present?
  end

  def both_have_same_gameweek
    return unless game_week_team.present?
    return unless match_player.present?

    mp_gw = match_player.game_week
    gwt_gw = game_week_team.game_week

    if gwt_gw.number != mp_gw.number
      errors.add(
        :base,
        'Game Weeks do not match!'
      )
    end
  end
end
