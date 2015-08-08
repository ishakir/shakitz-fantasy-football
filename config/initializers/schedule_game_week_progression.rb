require 'rufus-scheduler'
require 'game_week_progresser'

def format_for_rufus(time)
	time.strftime('%Y/%m/%d %H:%M:%S')
end

if not Settings.schedule or File.basename($0) == "rake"
	Rails.logger.info "Not in production mode, so not scheduling game week locking"
else
	Rails.logger.info "In production mode, so scheduling game week locking"
	scheduler = Rufus::Scheduler.new
	GameWeek.all.each do |game_week|
		rufus_time = format_for_rufus(game_week.lock_time.in_time_zone(Settings.local_timezone))
		Rails.logger.info "Scheduling game week progression for week #{game_week.number} at #{rufus_time}"
		scheduler.at rufus_time do 
			GameWeekProgresser.new.progress_game_week(game_week.number)
		end
	end
end