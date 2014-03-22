class GameWeekTeamPlayer < ActiveRecord::Base
  belongs_to :game_week_team
  belongs_to :match_player
end
