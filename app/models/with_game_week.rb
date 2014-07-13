# -*- encoding : utf-8 -*-
module WithGameWeek
  def validate_game_week_number(game_week_number)
    fail ArgumentError, "Game week number must be greater than 1, not #{game_week_number}" if game_week_number < 1
    fail ArgumentError, "Game week number must be less than 17, not #{game_week_number}" if game_week_number > 17
  end

  def up_to_game_week(list, game_week_number)
    validate_game_week_number(game_week_number)
    list.select do |item|
      item.game_week.number <= game_week_number
    end
  end

  def for_game_week(list, game_week_number)
    validate_game_week_number(game_week_number)
    candidates = list.select do |item|
      item.game_week.number == game_week_number
    end
    if candidates.empty?
      fail IllegalStateError, "No game week team found for id #{id}, game week #{game_week_number}"
    end
    if candidates.size > 1
      fail IllegalStateError, "#{candidates.size} game week teams found with user_id #{id}, game week #{game_week_number}"
    end
    candidates.first
  end
end
