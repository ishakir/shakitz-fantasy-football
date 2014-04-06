class NflPlayer < ActiveRecord::Base
  belongs_to :nfl_team
  belongs_to :nfl_player_type

  has_many :match_players

  validates_presence_of :name
  validates_presence_of :nfl_player_type
end
