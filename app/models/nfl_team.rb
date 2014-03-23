class NflTeam < ActiveRecord::Base
  has_many :nfl_players 
end
