# -*- encoding : utf-8 -*-
class GameWeekTeam < ActiveRecord::Base
  belongs_to :user
  belongs_to :game_week

  has_many :game_week_team_players
  has_many :match_players, through: :game_week_team_players

  validates :user,
            presence: true,
            uniqueness: { scope: :game_week, if: :both_are_present }

  validates :game_week,
            presence: true

  def both_are_present
    user.present? && game_week.present?
  end

  def match_players_playing
    match_players_by_status(true)
  end

  def match_players_benched
    match_players_by_status(false)
  end

  def match_players_by_status(playing)
    gwt_players = game_week_team_players.select do |gwtp|
      gwtp.playing == playing
    end
    gwt_players.map do |gwtp|
      gwtp.match_player
    end
  end

  def opponent
    # "Or" is not implemented yet :/
    fixtures = Fixture.where("home_team_id = #{id} or away_team_id = #{id}")
    return nil if fixtures.empty?
    fail IllegalStateException if fixtures.size > 1
    fixtures[0].opponent_of(self)
  end

  def points
    # This is a functional "fold"
    match_players_playing.reduce(0) do |sum, player|
      sum + player.points
    end
  end
end
