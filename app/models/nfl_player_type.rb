class NflPlayerType < ActiveRecord::Base
  ALLOWED_TYPES = %w(QB WR RB TE D K)

  has_many :nfl_players

  validates_inclusion_of :position_type, in: ALLOWED_TYPES, allow_nil: false
  validates_uniqueness_of :position_type
end
