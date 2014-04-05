class NflPlayer < ActiveRecord::Base
  belongs_to :nfl_team
  belongs_to :nfl_player_type

  has_many :match_players

  validates :name, presence: true
  validates :nfl_player_type, presence: true
end
