require 'thor/util'

module PointsStrategy
  def self.new(plugin, match_player)
    require("points_strategy/#{plugin}")

    string_constant = Thor::Util.camel_case(plugin)
    klass = const_get(string_constant)
    klass.new(match_player)

  rescue LoadError
    raise ArgumentError, "No such points strategy #{plugin}"
  end
end
