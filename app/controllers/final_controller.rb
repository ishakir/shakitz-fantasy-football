require 'best_team'

class FinalController < ApplicationController
  caches_page :show

  def show
    @winner = winner
    @head_to_head_winner = head_to_head_winner

    @total_points_proportion = proportion_of_points_by_type(MatchPlayer.all)
    @total_points_proportion_by_user = total_points_proportion_by_user

    @std_dev_per_user = Hash[User.all.map { |user| [user, user.game_week_teams.map(&:points).standard_deviation] }]
    @best_team = BestTeam.find_ten_best_players(NflPlayer.all.map { |nfl_player| [nfl_player, nfl_player.points] })
  end

  private

  def total_points_proportion_by_user
    all_playing_gwtps_by_user = GameWeekTeamPlayer.all.select(&:playing).group_by { |gwtp| gwtp.game_week_team.user }
    Hash[
      all_playing_gwtps_by_user.map { |user, gwtps| [user, proportion_of_points_by_type(gwtps.map(&:match_player))] }
    ]
  end

  def proportion_of_points_by_type(match_players)
    grouped = match_players.group_by { |player| player.nfl_player.nfl_player_type.position_type }
    Hash[grouped.map { |type, mps| [type, mps.map(&:points).sum] }]
  end

  def winner
    User.all.max_by(&:points)
  end

  def head_to_head_winner
    User.all.max_by do |user|
      results = user.all_results
      [results[:wins], results[:draws]]
    end
  end
end
