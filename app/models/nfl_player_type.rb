class NflPlayerType < ActiveRecord::Base
  
  Allowed_Types = ["QB", "WR", "RB", "TE", "D", "K"]
  
  has_many :nfl_players
  
  validates_inclusion_of :position_type, :in => Allowed_Types, :allow_nil => false
  
  def type_is_allowed
    if(!Allowed_Types.include?(position_type))
      errors.add(:position_type, "Position Type #{position_type} is not allowed")
    end
  end
  
end
