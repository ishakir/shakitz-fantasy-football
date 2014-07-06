# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  include WithGameWeek

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

  def won_up_to_game_week(game_week_number)
    wins = teams_up_to_game_week(game_week_number).select do |game_week_team|
      game_week_team.head_to_head_result == :won
    end
    wins.size
  end

  def drawn_up_to_game_week(game_week_number)
    draws = teams_up_to_game_week(game_week_number).select do |game_week_team|
      game_week_team.head_to_head_result == :drawn
    end
    draws.size
  end

  def lost_up_to_game_week(game_week_number)
    losses = teams_up_to_game_week(game_week_number).select do |game_week_team|
      game_week_team.head_to_head_result == :lost
    end
    losses.size
  end

  def teams_up_to_game_week(game_week_number)
    up_to_game_week(game_week_teams, game_week_number)
  end

  def team_for_game_week(game_week)
    game_week_as_number = game_week.to_i
    for_game_week(game_week_teams, game_week_as_number)
  end

  def points
    # This is a functional "fold"
    game_week_teams.reduce(0) do |sum, game_week_team|
      sum + game_week_team.points
    end
  end
end
