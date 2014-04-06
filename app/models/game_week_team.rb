class GameWeekTeam < ActiveRecord::Base
  belongs_to :user
  belongs_to :game_week

  has_many :game_week_team_players
  has_many :match_players, through: :game_week_team_players

  validates_presence_of :user
  validates_presence_of :game_week

  validates_uniqueness_of :user, scope: :game_week, if: :both_are_present

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

  def points
    # This is a functional "fold"
    match_players_playing.reduce(0) do |sum, player|
      sum + player.points
    end
  end
end
