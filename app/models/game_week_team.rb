class GameWeekTeam < ActiveRecord::Base
  
  validates :user, presence: true
  
  belongs_to :user
  
  has_many :game_week_team_players
  has_many :match_players, through: :game_week_team_players
  
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

end
