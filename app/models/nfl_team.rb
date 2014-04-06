class NflTeam < ActiveRecord::Base
  has_many :nfl_players

  validates_presence_of :name
  validates_uniqueness_of :name
end
