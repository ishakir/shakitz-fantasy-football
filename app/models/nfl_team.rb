# -*- encoding : utf-8 -*-
class NflTeam < ActiveRecord::Base
  has_many :nfl_players

  validates :name,
            presence: true,
            uniqueness: true
end
