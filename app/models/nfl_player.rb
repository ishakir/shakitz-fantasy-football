class NflPlayer < ActiveRecord::Base
  
  validates :name, presence: true
  has_many :match_player
end
