require 'shakitz_scheduler'
require 'game_week_progresser'

if not Settings.schedule or File.basename($0) == "rake"
	Rails.logger.info "Not in production mode, so not scheduling game week locking"
else
	scheduler = ShakitzScheduler.new
	
	GameWeek.all.each do |game_week|
		scheduler.at game_week.lock_time, "progression for week #{game_week.number}" do
			Rails.logger.info("Progressing from game week #{game_week.number} to game week #{game_week.number + 1}")
			GameWeekProgresser.new.progress_game_week(game_week.number)
		end
	end
end