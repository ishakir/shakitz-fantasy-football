# -*- encoding : utf-8 -*-
class NflPlayerType < ActiveRecord::Base
  ALLOWED_TYPES = %w(QB WR RB TE D K)

  has_many :nfl_players

  validates :position_type,
            uniqueness: true,
            inclusion: { in: ALLOWED_TYPES, allow_nil: false }
end
