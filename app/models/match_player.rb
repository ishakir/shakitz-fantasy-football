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

  def game_week_team
    if game_week_teams.length > 2
      fail_too_many_game_week_teams
    elsif game_week_teams.empty?
      nil
    else
      game_week_teams[0]
    end
  end

  def self.top_overall_scorers
    MatchPlayer.connection.select_all("select sum(mp.points) as points, np.name, npt.position_type
      from match_players as mp, nfl_players as np, nfl_player_types as npt
      where mp.nfl_player_id = np.id
      and np.nfl_player_type_id = npt.id
      group by np.id, np.name, npt.position_type
      order by nfl_player_type_id, points desc")
  end

  private

  def fail_too_many_game_week_teams
    users = game_week_teams.map { |game_week_team| game_week_team.user.name }.join(',')
    raise IllegalStateError, "More than one team (#{users}) for #{nfl_player.name} in week #{game_week.number}!"
  end
end
