# -*- encoding : utf-8 -*-
require 'player_finder/name_finder/name_only_finder'
require 'player_finder/name_finder/name_team_finder'
require 'player_finder/name_finder/name_type_finder'
require 'player_finder/name_finder/name_team_type_finder'

module PlayerFinder
  module NameFinder
    def self.new(id_hash)
      return NameTeamTypeFinder.new(id_hash) if id_hash.key?(TYPE_KEY) && id_hash.key?(TEAM_KEY)
      return NameTeamFinder.new(id_hash)     if id_hash.key?(TEAM_KEY)
      return NameTypeFinder.new(id_hash)     if id_hash.key?(TYPE_KEY)
      NameOnlyFinder.new(id_hash)
    end
  end
end
