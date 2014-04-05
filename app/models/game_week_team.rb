class GameWeekTeam < ActiveRecord::Base
  belongs_to :user
  belongs_to :game_week

  has_many :game_week_team_players
  has_many :match_players, through: :game_week_team_players

  validates :user, presence: true
  validates :game_week, presence: true

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
