require 'shakitz_scheduler'

def generate_minute_intervals(start_time, no_hours)
	(0 .. no_hours * 4).map do |val|
		start_time + (15 * val).minutes
	end
end

if not Settings.schedule or File.basename($0) == "rake"
	Rails.logger.info "Not in production mode, so not scheduling stats updates"
else
	# Scheule stats updates every 15 mins during the games, which can happen on 
	all_update_times = (0 ... Settings.number_of_gameweeks).map do |week_number|
		start = WithGameWeek.start_of_first_gameweek + (week_number * 7).days
		# TODO: check this covers ALL games
		[
			# Thursday
			generate_minute_intervals(start + 2.days + 12.hours + 30.minutes, 12), 
			# Sunday
			generate_minute_intervals(start + 5.days + 13.hours, 13),
			# Monday
			generate_minute_intervals(start + 6.days + 19.hours, 8)
		].flatten
	end

	scheduler = ShakitzScheduler.new

	all_update_times.each_with_index do |times, index|
		week_number = index + 1
		host = "localhost"
		port = Settings.port
		year = WithGameWeek.start_of_first_gameweek.year
		kind = Settings.season_type

		times.each do |time|
			scheduler.at time, "stats update for week #{week_number}" do
				Rails.logger.info "Uploading stats for week #{week_number}"
				result = `python python/update_stats.py --host localhost --port #{port} --year #{year} --kind #{kind} --game_week #{week_number}`
				Rails.logger.info("Finished uploading stats, stdout was: ")
				Rails.logger.info(result)
			end
		end
	end
	
end