# -*- encoding : utf-8 -*-
module WithGameWeek
  def validate_game_week_number(game_week_number)
    fail ArgumentError, "Game week number must be greater than 1, not #{game_week_number}" if game_week_number < 1
    fail ArgumentError, "Game week number must be less than #{Settings.number_of_gameweeks}, not #{game_week_number}" if game_week_number > Settings.number_of_gameweeks
  end

  def for_current_game_week(list)
    for_game_week(list, current_game_week)
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
      fail IllegalStateError, "Nothing found for id #{id}, game week #{game_week_number}"
    end
    if candidates.size > 1
      fail IllegalStateError, "#{candidates.size} found with id #{id}, game week #{game_week_number}"
    end
    candidates.first
  end

  private

  def current_game_week
    number_of_days = (DateTime.now - DateTime.parse(Settings.first_gameweek_start)).floor
    return 1 if number_of_days == 0
    (number_of_days - (number_of_days % 7)) / 7
  end
end
