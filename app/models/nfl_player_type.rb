class NflPlayerType < ActiveRecord::Base
  validates :position_type, presence: true
  has_many :nfl_players
end
