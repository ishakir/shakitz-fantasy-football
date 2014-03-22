class MatchPlayer < ActiveRecord::Base
  belongs_to :nfl_player
  
  has_many :game_week_team_players
  has_many :game_week_teams, through: :game_week_team_players
  
end
