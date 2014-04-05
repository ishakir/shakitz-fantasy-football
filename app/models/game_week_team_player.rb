class GameWeekTeamPlayer < ActiveRecord::Base
  belongs_to :game_week_team
  belongs_to :match_player

  validates :game_week_team, presence: true
  validates :match_player, presence: true
  validate :both_have_same_gameweek

  def both_have_same_gameweek
    return unless game_week_team.present?
    return unless match_player.present?

    mp_gw = match_player.game_week
    gwt_gw = game_week_team.game_week

    if gwt_gw.number != mp_gw.number
      errors.add(
        :base,
        'GameWeekTeam and MatchPlayer do not have the same game week'
      )
    end
  end
end
