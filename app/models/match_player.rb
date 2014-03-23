class MatchPlayer < ActiveRecord::Base
  belongs_to :nfl_player
  belongs_to :game_week
  
  has_many :game_week_team_players
  has_many :game_week_teams, through: :game_week_team_players
  
end
