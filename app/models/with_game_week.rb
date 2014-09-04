# -*- encoding : utf-8 -*-
module WithGameWeek
  def self.validate_game_week_number(game_week_number)
    fail ArgumentError, "Game week number must be greater than 1, not #{game_week_number}" if game_week_number < 1
    fail ArgumentError, "Game week number must be less than #{Settings.number_of_gameweeks}, not #{game_week_number}" if game_week_number > Settings.number_of_gameweeks
  end

  def for_current_game_week(list)
    for_game_week(list, WithGameWeek.current_game_week)
  end

  def up_to_game_week(list, game_week_number)
    WithGameWeek.validate_game_week_number(game_week_number)
    list.select do |item|
      item.game_week.number <= game_week_number
    end
  end

  def for_game_week(list, game_week_number)
    WithGameWeek.validate_game_week_number(game_week_number)
    candidates = list.select do |item|
      item.game_week.number == game_week_number
    end
    if candidates.empty?
      fail ActiveRecord::RecordNotFound, "Nothing found for id #{id}, game week #{game_week_number}"
    end
    if candidates.size > 1
      fail IllegalStateError, "#{candidates.size} found with id #{id}, game week #{game_week_number}"
    end
    candidates.first
  end

  def self.start_of_first_gameweek
    Time.zone = 'Eastern Time (US & Canada)'
    start = Time.zone.parse(Settings.first_gameweek_start) + 2.hours
    Rails.logger.info("Start time: #{start.strftime("%d/%m/%Y %H:%M:%S")}")
    start
  end

  def self.eastern_current_time
    eastern_time = DateTime.now.utc.in_time_zone('Eastern Time (US & Canada)')
    Rails.logger.info("Eastern Time: #{eastern_time.strftime("%d/%m/%Y %H:%M:%S")}")
    eastern_time
  end

  def self.is_more_than_time_since_start?(days, hours)
    eastern_current_time = WithGameWeek.eastern_current_time
    start_time = WithGameWeek.start_of_first_gameweek

    time_difference = eastern_current_time - start_time
    Rails.logger.info("Time difference is #{time_difference}")

    converted_days = days.days
    converted_hours = hours.hours

    Rails.logger.info("Converted days is #{converted_days}")
    Rails.logger.info("Converted hours is #{converted_hours}")

    total_converted_time = days.days + hours.hours
    Rails.logger.info("Total converted time is #{total_converted_time}")

    time_difference > total_converted_time
  end

  def self.current_game_week
    Rails.logger.info "Calculating current game week"

    eastern_current_time = WithGameWeek.eastern_current_time
    augmented_start_time = WithGameWeek.start_of_first_gameweek

    days_since_start = ((eastern_current_time - augmented_start_time) / 1.day).floor
    Rails.logger.info "Days since start is #{days_since_start}"

    game_week = ((days_since_start - (days_since_start % 7)) / 7) + 1

    Rails.logger.info "Returning from current_game_week with #{game_week}"

    return 1 if game_week < 1
    game_week
  end
end
