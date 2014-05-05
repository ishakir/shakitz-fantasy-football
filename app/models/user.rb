# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  validates :name,
            presence: true,
            uniqueness: true

  validates :team_name,
            presence: true
            
  has_many :game_week_teams, dependent: :destroy

  def opponents
    opponents = game_week_teams.map do |game_week_team|
      game_week_team.opponent
    end
    opponents.compact
  end

  def team_for_game_week(game_week_number)
    fail ArgumentError, "Game week number must be greater than 1, not #{game_week_number}" if game_week_number < 1
    fail ArgumentError, "Game week number must be less than 17, not #{game_week_number}" if game_week_number > 17
    teams = game_week_teams.select do |game_week_team|
      game_week_team.game_week.number == game_week_number
    end
    fail IllegalStateException if teams.empty?
    fail IllegalStateException if teams.size > 1
    teams[0]
  end

  def points
    # This is a functional "fold"
    game_week_teams.reduce(0) do |sum, game_week_team|
      sum + game_week_team.points
    end
  end
end
