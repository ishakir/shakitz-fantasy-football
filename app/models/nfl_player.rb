class NflPlayer < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :nfl_team
  belongs_to :nfl_player_type
  has_many :match_players
end
