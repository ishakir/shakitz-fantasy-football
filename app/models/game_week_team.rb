class GameWeekTeam < ActiveRecord::Base
  
  validates :user, presence: true
  
  belongs_to :user
  
  has_many :game_week_team_players
  has_many :match_players, through: :game_week_team_players

end
