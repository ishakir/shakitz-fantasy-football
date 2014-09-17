module PointsStrategy
  class Base
    def initialize(match_player)
      @match_player = match_player
    end

    # Utility Methods
    def points_per_number_of_attribute(attribute, how_many_per_point)
      (attribute - (attribute % how_many_per_point)) / how_many_per_point
    end
  end
end
