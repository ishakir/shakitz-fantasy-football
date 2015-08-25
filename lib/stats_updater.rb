class StatsUpdater

	def self.update_stats
		week_number = WithGameWeek.current_game_week
		host = "localhost"
		port = Settings.port
		year = WithGameWeek.start_of_first_gameweek.year
		kind = Settings.season_type

		if week_number > 0 and week_number < Settings.number_of_gamweeks + 1
			Rails.logger.info "Uploading stats for week #{week_number}"
			result = `python python/update_stats.py --host #{host} --port #{port} --year #{year} --kind #{kind} --game_week #{week_number}`
			Rails.logger.info("Finished uploading stats, stdout was: ")
			Rails.logger.info(result)
		else
			raise "Cannot update stats for week #{week_number} as it doesn't exist!"
		end
	end

end