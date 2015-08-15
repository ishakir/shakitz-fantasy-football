require 'rufus-scheduler'

# Wrapper for Rufus::Scheduler that provides some niceties, like converting timezones under the covers
# and not scheduling events that are in the future
class ShakitzScheduler
  def initialize
    @scheduler = Rufus::Scheduler.new
  end

  def at(time, description)
    if time > Time.zone.now
      local_time = convert_timezone(time)
      Rails.logger.info "Scheduling #{description} for " \
        "#{format_for_rufus(time)} in #{Time.zone} which we converted to " \
        "#{format_for_rufus(local_time)} in #{Settings.local_timezone}"
      @scheduler.at format_for_rufus(local_time) do
        yield
      end
    else
      Rails.logger.info "Didn't schedule #{description} at #{time} because it's in the past!"
    end
  end

  def in(time_string, description)
    Rails.logger.info "Scheduling #{description} in #{time_string}"
    @scheduler.in time_string do
      yield
    end
  end

  private

  def convert_timezone(time)
    time.in_time_zone(Settings.local_timezone)
  end

  def format_for_rufus(time)
    time.strftime('%Y/%m/%d %H:%M:%S')
  end
end
