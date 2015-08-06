require 'rufus-scheduler'

def generate_minute_intervals(start_time, no_hours)
	(0 .. no_hours * 4).map do |val|
		start_time + (15 * val).minutes
	end
end

def format_for_rufus(time)
	time.strftime('%Y/%m/%d %H:%M:%S')
end

def schedule_stats_update(week_number, time, scheduler)
	year = WithGameWeek.start_of_first_gameweek.year
	kind = Settings.season_type
	port = Rails::Server.new.options[:Port]
	rufus_time = format_for_rufus(time)
	Rails.logger.info "Scheduling stats update for week #{week_number} at #{rufus_time}"
	scheduler.at rufus_time do
		Rails.logger.info "Uploading stats for week #{week_number}"
		result = `python python/update_stats.py --host localhost --port #{port} --year #{year} --kind #{kind} --game_week #{week_number}`
		Rails.logger.info("Finished uploading stats")
		Rails.logger.info(result)
	end
end

if not Settings.schedule or File.basename($0) == "rake"
	Rails.logger.info "Not in production mode, so not scheduling stats updates"
else
	# Scheule stats updates every 15 mins during the games, which can happen on 
	all_update_times_in_est = (0 ... Settings.number_of_gameweeks).map do |week_number|
		start = WithGameWeek.start_of_first_gameweek + (week_number * 7).days
		# TODO: check this covers ALL games
		all_update_times = [
			# Thursday
			generate_minute_intervals(start + 2.days + 12.hours + 30.minutes, 12), 
			# Sunday
			generate_minute_intervals(start + 5.days + 13.hours, 13),
			# Monday
			generate_minute_intervals(start + 6.days + 19.hours, 8)
		].flatten
	end

	all_update_times_in_local_timezone = all_update_times_in_est.map do |times|
		times.map do |time| time.in_time_zone(Settings.local_timezone) end
	end

	scheduler = Rufus::Scheduler.new

	all_update_times_in_local_timezone.each_with_index do |times, index|
		times.each do |time|
			schedule_stats_update(index + 1, time, scheduler)
		end
	end
	
end