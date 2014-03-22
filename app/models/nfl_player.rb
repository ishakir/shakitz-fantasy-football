class NflPlayer < ActiveRecord::Base
  
  validates :name, presence: true
  
  belongs_to :nfl_team
  
  has_many :match_players

end
