# -*- encoding : utf-8 -*-
require 'player_finder/id_finder'
require 'player_finder/team_type_finder'
require 'player_finder/name_finder'

module PlayerFinder
  ID_KEY   = :id
  NAME_KEY = :name
  TEAM_KEY = :team
  TYPE_KEY = :type

  def self.new(id_hash)
    return IdFinder.new(id_hash)       if id_hash.key?(ID_KEY)
    return NameFinder.new(id_hash)     if id_hash.key?(NAME_KEY)
    return TeamTypeFinder.new(id_hash) if team_and_type?(id_hash)
    return :only_team                  if id_hash.key?(TYPE_KEY)
    return :only_type                  if id_hash.key?(TEAM_KEY)
  end

  private_class_method

  def self.team_and_type?(id_hash)
    id_hash.key?(TYPE_KEY) && id_hash.key?(TEAM_KEY)
  end
end
