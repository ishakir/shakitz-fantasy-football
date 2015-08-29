year = WithGameWeek.start_of_first_gameweek.year
port = Settings.port
kind = Settings.season_type

if NflPlayer.all.empty?
	Rails.logger.info("Attemping to upload initial players")
	result = `python python/create_initial_players.py --host localhost --port #{port} --year #{year} --kind #{kind}`
	Rails.logger.info("Finished uploading initial players, stdout was:")
	Rails.logger.info(result)
else
	raise 'Already found players in the database, aborting'
end